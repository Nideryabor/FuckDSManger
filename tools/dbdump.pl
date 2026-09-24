#!/usr/bin/perl
# 用法: perl dbdump.pl <文件> [最小长度,默认4]
# 作用: 1) 判断是否 SQLite(看文件头) 2) 提取所有可打印字符串(ASCII + UTF-8 中文)
use strict; use warnings;

my $f = shift or die "usage: dbdump.pl <file> [minlen]\n";
my $min = shift // 4;

open(my $fh, '<:raw', $f) or die "open $f: $!\n";
local $/; my $d = <$fh>; close $fh;
my $len = length($d);
printf "FILE %s  size=%d bytes\n", $f, $len;

# 1) 文件头
my $hdr = substr($d, 0, 16);
printf "HDR  %s\n", unpack('H*', $hdr);
printf "HDR  ascii=[%s]\n", join('', map { ($_ >= 32 && $_ < 127) ? chr($_) : '.' } unpack('C*', $hdr));
if ($hdr =~ /^SQLite format 3\x00/) {
    print "HDR  ==> 标准 SQLite 明文库（未加密）\n";
} else {
    print "HDR  ==> 不是标准 SQLite 头（可能是加密库，或不是 db 文件）\n";
}

# 2) 抽取可读串（按字节扫，收集 >=min 的连续可打印/UTF8 序列）
my @out;
my $cur = '';
for my $i (0 .. $len - 1) {
    my $c = ord(substr($d, $i, 1));
    if (($c >= 32 && $c < 127) || $c == 9 || $c == 10 || $c >= 0x80) {
        $cur .= chr($c);
    } else {
        push @out, $cur if length($cur) >= $min;
        $cur = '';
    }
}
push @out, $cur if length($cur) >= $min;

printf "STR  extracted=%d\n", scalar(@out);
print "-" x 60, "\n";
print "$_\n" for @out;
