package App::TermNote::Pane;
use strict;
use warnings;

use Class::Accessor::Lite (
    ro => [qw/title/],
);

use POSIX ();
use Term::ANSIColor ();
use App::TermNote::Util qw/string_width/;

sub render {
    my ($self, $width, $height, $header) = @_;

    _clear();
    if ($self->title) {
        printf "$header - %s\n", ($self->title || '');
    } else {
        print "$header\n";
    }

    print $self->spaces($height);
    print $self->formatted_rows($width);
    print $self->spaces($height);

    return 0;
}

sub _clear {
    my $clear_cmd = $^O eq 'MSWin32' ? 'cls' : 'clear';
    system $clear_cmd;
}

sub formatted_rows {
    my ($self, $width) = @_;

    my @rows = $self->rows;
    return join "\n", map { $self->guttered_row($_, $width) } @rows;
}

sub guttered_row {
    my ($self, $row, $width) = @_;

    my $row_width = string_width(Term::ANSIColor::colorstrip($row));
    my $padding = " " x $self->gutter_width($row, $width);

    return $padding . $row;
}

sub gutter_width {
    my ($self, $row, $width) = @_;
    my $row_width = string_width(Term::ANSIColor::colorstrip($row));
    return POSIX::floor($width / 2) - POSIX::ceil($row_width / 2);
}

sub spaces {
    my ($self, $height) = @_;
    return "\n" x (int($height / 2) - 2);
}

1;
