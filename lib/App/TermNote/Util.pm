package App::TermNote::Util;
use strict;
use warnings;

use parent qw/Exporter/;

use Term::ANSIColor qw(:constants);
use Unicode::EastAsianWidth;

our @EXPORT = qw/wrapped_title wrap_bold string_width/;

our $wrapped_width = 80;

sub string_width {
    my $str = shift;

    my $ret = 0;
    while ($str =~ /(?:(\p{InFullwidth}+)|(\p{InHalfwidth}+))/go) {
        $ret += ($1 ? length($1) * 2 : length($2));
    }

    return $ret;
}

sub wrapped_title {
    my $title = shift;

    my @chars = split //, $title;
    my @lines;

    my $len = scalar @chars;
    my $total_width = 0;
    my $line = '';
    for (my $i = 0; $i < $len; $i++) {
        my $width = string_width($chars[$i]);

        if (($total_width + $width) < 80) {
            $total_width += $width;
            $line .= $chars[$i];
        } elsif (($total_width + $width) == 80) {
            push @lines, ($line . $chars[$i]);
            $line = '';
            $total_width = 0;
        } else {
            push @lines, $line;
            $line = $chars[$i];
            $total_width = $width;
        }
    }

    push @lines, $line unless $line eq '';

    return @lines;
}

sub wrap_bold {
    my @lines = @_;
    return map { BOLD . $_ . RESET } @lines;
}

1;
