#!/usr/bin/perl
# 用法: perl sqlite_rows.pl <db文件> [关键字过滤]
# 作用: 不依赖 sqlite3，直接按 SQLite 文件格式遍历【叶子表页】的 cells，
#       按 rowid 顺序输出每个 cell 里的可读字符串（只打印结构/长度，正文自动截断打码）
use strict; use warnings;

my $f    = shift or die "usage: sqlite_rows.pl <file> [filter]\n";
my $filt = shift // '';

open(my $fh, '<:raw', $f) or die "open: $!\n";
local $/; my $d = <$fh>; close $fh;
my $len = length($d);

# --- 头 ---
die "not sqlite\n" unless substr($d,0,16) eq "SQLite format 3\0";
my $ps = unpack('n', substr($d,16,2));      # page size
$ps = 65536 if $ps == 1;
printf "PAGE_SIZE %d  FILE %d bytes\n", $ps, $len;
my $npages = int($len / $ps);
printf "PAGES %d\n", $npages;
print "-" x 70, "\n";

sub u8  { unpack('C', $_[0]) }
sub u16 { unpack('n', $_[0]) }
sub u32 { unpack('N', $_[0]) }
# varint
sub varint {
    my ($s, $off) = @_;
    my $v = 0; my $n = 0;
    for my $i (0..8) {
        my $b = u8(substr($s, $off+$i, 1));
        if ($i == 8) { $v = ($v << 8) | $b; $n = 9; last }
        $v = ($v << 7) | ($b & 0x7f);
        $n = $i+1;
        last unless ($b & 0x80);
    }
    return ($v, $n);
}
sub printable_runs {
    my ($s, $min) = @_;
    my @r; my $cur = '';
    for my $i (0 .. length($s)-1) {
        my $c = ord(substr($s,$i,1));
        if (($c>=32 && $c<127) || $c>=0x80) { $cur .= substr($s,$i,1) }
        else { push @r, $cur if length($cur) >= $min; $cur = '' }
    }
    push @r, $cur if length($cur) >= $min;
    return @r;
}

my $rows = 0;
for my $p (0 .. $npages-1) {
    my $off = $p * $ps;
    next if $off + 8 > $len;
    my $t = u8(substr($d,$off,1));
    next unless $t == 0x0D;                       # 0x0D = 表叶子页
    my $ncell = u16(substr($d,$off+3,2));
    next if $ncell == 0;
    my $hdr = 8;                                  # 叶子页头 8 字节
    my @cells;
    for my $i (0 .. $ncell-1) {
        my $co = $hdr + $i*2;
        next if $off+$co+2 > $len;
        my $cp = u16(substr($d,$off+$co,2));
        push @cells, $cp;
    }
    for my $cp (sort { $a <=> $b } @cells) {
        my $base = $off + $cp;
        next if $base + 2 > $len;
        my ($plen, $n1) = varint($d, $base);
        my ($rowid, $n2) = varint($d, $base+$n1);
        my $pstart = $base + $n1 + $n2;
        my $payload = substr($d, $pstart, $plen);
        next if length($payload) < 4;
        $rows++;
        my @s = printable_runs($payload, 6);
        my $joined = join(' | ', @s);
        next if $filt && $joined !~ /\Q$filt\E/;
        # 只打印结构：rowid / 长度 / 各串的类型与长度，正文截断打码
        my @desc;
        for my $s (@s) {
            my $mark = '';
            if    ($s =~ /^\{"type":"REQUEST"/)  { $mark = 'REQ' }
            elsif ($s =~ /^\{"type":"RESPONSE"/) { $mark = 'RESP' }
            elsif ($s =~ /^CREATE TABLE/)        { $mark = 'SCHEMA' }
            elsif ($s =~ /^(USER|ASSISTANT|SYSTEM)$/) { $mark = $s }
            my $head = substr($s, 0, 24);
            $head =~ s/\n/\\n/g;
            push @desc, sprintf("%s[len=%d]%s", ($mark ? "$mark:" : ""), length($s), $head);
        }
        printf "rowid=%-4s payload=%-6d | %s\n", $rowid, $plen, join(' ;; ', @desc);
    }
}
printf "%s\nTOTAL_ROWS %d\n", "-" x 70, $rows;
