package App::TermNote::Pane::Code;
use strict;
use warnings;

use parent qw/App::TermNote::Pane/;

use App::TermNote::Util qw/wrapped_title wrap_bold/;
use Text::VimColor;

sub new {
    my ($class, $document) = @_;

    my $syntax = Text::VimColor->new(
        string   => $document->{source},
        filetype => $document->{language},
    );

    bless {
        syntax => $syntax,
    }, $class;
}

sub rows {
    my $self = shift;

    my $highlighted = $self->{syntax}->ansi;
    return split /\n/, $highlighted;
}

sub gutter_width {
    my ($self, $row, $width) = @_;
    return int($width * 0.25)
}

sub spaces {
    my ($self, $height) = @_;
    my $code_size = scalar($self->rows);
    my $newlines = $height > $code_size ? ($height - $code_size) / 2 : 0;

    return "\n" x $newlines;
}

1;
