#!/usr/bin/perl
# vercheck.pl v2 —— 迷你 smali verifier（类型感知版）
#
# 用途：纯手写 smali 项目里最常见的两类 VerifyError：
#   (1) "register vN has type Undefined but expected ..."
#       ＝ 某条跳转路径绕过了 vN 的初始化，而目标标签后又用了 vN
#   (2) "register vN has type <A> but expected <B>"（merge 点类型冲突）
#       ＝ 同一个 vN 在两条路径上被写成不同类型（寄存器复用撞车）
#   MT 的 edit_check 不做字节码校验（铁律 6），本脚本用来补这一刀。
#
# 输入：mt_apk_read_text 抓下来的 class JSON（含 "textWindow":{"text":"..."}）
# 输出：逐方法报告「未初始化」/「类型冲突」的使用点
#
# 用法： perl vercheck.pl <saved_tool_output.txt>
#
# 与 ART verifier 的差异（刻意保守）：
#   * 只检查「是否已写」+「对象家族 vs int 家族」两档类型，不做精确类层次
#   * const/4 vX, 0x0 记为 "zero"（Android 的 Zero 类型：可 merge 成 int 也可成引用）
#   * 参数寄存器 p0..pN 恒为已定义
#   * 不进入 catch handler（handler 首句惯例是 move-exception，另算）
use strict; use warnings;

my $file = shift or die "usage: vercheck.pl <saved_tool_output.txt>\n";
open(my $fh, '<', $file) or die "open $file: $!";
local $/; my $raw = <$fh>; close $fh;

my $t;
if ($raw =~ /"text":"(.*?)","startLine":/s) { $t = $1; }
else { $t = $raw; }
$t =~ s/\\n/\n/g; $t =~ s/\\"/"/g; $t =~ s/\\t/\t/g; $t =~ s/\\\\/\\/g;

# ---- 操作码分类 ----------------------------------------------------------
my %WIDE = map { $_ => 1 } qw(
  const-wide const-wide/16 const-wide/32 const-wide/high16
  move-wide move-wide/from16 move-wide/16 move-result-wide
  add-long sub-long mul-long div-long rem-long neg-long not-long
  and-long or-long xor-long shl-long shr-long ushr-long
  int-to-long long-to-int long-to-float float-to-long
  cmp-long aget-wide aput-wide iget-wide sget-wide iput-wide sput-wide
  add-double sub-double mul-double div-double rem-double neg-double
  int-to-double double-to-int long-to-double double-to-long
  cmp-double cmp-float
);

# 写入结果类型（粗粒度：int 家族 / 对象家族 / zero / long）
sub write_type {
    my ($op, $txt) = @_;
    return 'zero'   if $op =~ m{^const(?:/4|/16|/32|/high16)?$} && $txt =~ /,\s*0x0+\s*$/;
    return 'long'   if $WIDE{$op};
    return 'string' if $op eq 'const-string';
    return 'class'  if $op eq 'const-class';
    return 'obj'    if $op eq 'new-instance' || $op eq 'new-array';
    return 'obj'    if $op =~ m{^(move-object|move-result-object)};
    return 'obj'    if $op =~ m{^(sget|iget|aget)-object};
    return 'obj'    if $op eq 'move-exception';
    return 'int';
}

sub is_obj { my $t = shift; return 0 unless defined $t; return $t =~ /^(string|class|arr|obj)/ ? 1 : 0; }

sub lub {
    my ($a, $b) = @_;
    return $a unless defined $b;
    return $b unless defined $a;
    return $a if $a eq $b;
    return $b if $a eq 'zero';
    return $a if $b eq 'zero';
    return 'undef' if $a eq 'undef' || $b eq 'undef';
    return 'conflict' if $a eq 'conflict' || $b eq 'conflict';
    return 'obj' if is_obj($a) && is_obj($b);
    return 'conflict';
}

sub merge_state {
    my ($old, $new) = @_;
    my %all; $all{$_} = 1 for (keys %$old, keys %$new);
    my %m;
    for my $k (keys %all) {
        my $ha = exists $old->{$k}; my $hb = exists $new->{$k};
        if ($ha && $hb) { $m{$k} = lub($old->{$k}, $new->{$k}); }
        else            { $m{$k} = 'undef'; }
    }
    return \%m;
}

# ---- 逐方法扫描 ---------------------------------------------------------
my @lines = split /\n/, $t;
my ($cur_method, @body);
my @reports;
my %seen;

sub flush_method {
    my ($mname, $body, $out) = @_;
    return unless defined $mname and @$body;
    my $n = @$body;
    my %label;
    for my $i (0 .. $n - 1) {
        $label{ $body->[$i]{text} } = $i + 1 if $body->[$i]{kind} eq 'label';
    }
    my @state;
    $state[0] = { };
    my @queue = (0);
    my $guard = 0;
    while (@queue) {
        last if ++$guard > 500000;
        my $i = shift @queue;
        next if $i >= $n;
        my $ins = $body->[$i];
        my $st = $state[$i] || { };
        my @s;
        if ($ins->{kind} eq 'label') {
            @s = ($i + 1);
            $st = { %$st };                       # 拷贝，别让后继污染
        } else {
            for my $r (@{ $ins->{read} }) {
                next if $r =~ /^p\d+$/;
                my $ty = $st->{$r};
                next if defined $ty && $ty ne 'undef' && $ty ne 'conflict';
                my $key = "$mname|$i|$r";
                next if $seen{$key}++;
                my $why = !defined $ty ? '未初始化（Undefined）'
                        : $ty eq 'undef' ? '分支合并后为 Undefined（某条路径没写它）'
                        : '分支合并后类型冲突（两条路径写成了不同类型）';
                push @$out, sprintf("  [%s] #%d  %s\n        ↳ 寄存器 %s：%s",
                                    $mname, $i, $ins->{text}, $r, $why);
            }
            my %ns = %$st;
            if (@{ $ins->{write} }) {
                my $ty = write_type($ins->{op}, $ins->{text});
                $ns{$_} = $ty for @{ $ins->{write} };
            }
            $st = \%ns;
            my $op = $ins->{op};
            if ($op =~ /^if-/) {
                my ($lbl) = ($ins->{text} =~ /(:[\w\$]+)\s*$/);
                push @s, $i + 1;
                push @s, $label{$lbl} if defined $lbl && defined $label{$lbl};
            } elsif ($op =~ m{^goto}) {
                my ($lbl) = ($ins->{text} =~ /(:[\w\$]+)\s*$/);
                push @s, $label{$lbl} if defined $lbl && defined $label{$lbl};
            } elsif ($op =~ m{^(return|throw)}) {
                # 无后继
            } else {
                push @s, $i + 1;
            }
        }
        for my $j (@s) {
            next if $j >= $n;
            my $old = $state[$j];
            if (!defined $old) {
                $state[$j] = { %$st };
                push @queue, $j;
            } else {
                my $m = merge_state($old, $st);
                my $changed = 0;
                my %all; $all{$_} = 1 for (keys %$old, keys %$m);
                for my $k (keys %all) {
                    my $x = exists $old->{$k} ? $old->{$k} : '__none__';
                    my $y = exists $m->{$k}   ? $m->{$k}   : '__none__';
                    if ($x ne $y) { $changed = 1; last; }
                }
                if ($changed) { $state[$j] = $m; push @queue, $j; }
            }
        }
    }
}

for my $ln (@lines) {
    (my $s = $ln) =~ s/^\s+|\s+$//g;
    if ($s =~ /^\.method\b/) { $cur_method = $s; @body = (); next; }
    if ($s =~ /^\.end method/) {
        flush_method($cur_method, \@body, \@reports);
        $cur_method = undef; @body = (); next;
    }
    next unless defined $cur_method;
    next if $s eq '';
    next if $s =~ /^\./;
    if ($s =~ /^(:[\w\$]+)$/) { push @body, { kind => 'label', text => $1 }; next; }
    my ($op) = $s =~ /^([\w\-\/\.]+)/;
    next unless defined $op;
    (my $nostr = $s) =~ s/"[^"]*"/""/g;      # 抹掉字符串字面量
    my @r = ($nostr =~ /\b([vp]\d+)\b/g);
    my (@read, @write);
    if ($op =~ /^if-/ || $op =~ m{^goto} || $op =~ m{^return|^throw}
        || $op =~ m{^invoke-|^filled-new-array}
        || $op =~ m{^aput|^iput|^sput}
        || $op =~ m{^monitor-|^nop$|^packed-switch|^sparse-switch}) {
        @read = @r;
    } elsif ($op eq 'move-exception') {
        @write = @r;
    } elsif ($op eq 'check-cast') {
        @read = @r; @write = @r;
    } else {
        if (@r) { @write = (shift @r); @read = @r; }
        if ($WIDE{$op} && @write && $write[0] =~ /^v(\d+)$/) {
            push @write, 'v' . ($1 + 1);
        }
    }
    push @body, { kind => 'ins', op => $op, text => $s, read => \@read, write => \@write };
}

if (@reports) {
    print "❌ 发现 ", scalar(@reports), " 处隐患：\n";
    print "$_\n" for @reports;
} else {
    print "✅ 未发现未初始化 / 类型冲突隐患\n";
}
