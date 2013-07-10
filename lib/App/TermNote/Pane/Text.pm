package App::TermNote::Pane::Text;
use strict;
use warnings;

use parent qw/App::TermNote::Pane/;

use App::TermNote::Util qw/wrapped_title wrap_bold/;

sub new {
    my ($class, $document) = @_;

    bless {
        title   => $document->{title},
        content => $document->{content},
    }, $class;
}

sub rows {
    my $self = shift;

    my @ret = _content_row($self->{content});
    if ($self->{title}) {
        unshift @ret, wrapped_title($self->{title});
    }

    return @ret;
}

sub _content_row {
    my $content = shift;
    return split /\n/, $content;
}

sub gutter_width {
    my ($self, $row, $width) = @_;
    return int($width * 0.25)
}

sub spaces {
    my ($self, $height) = @_;
    my $text_size = scalar(wrapped_title($self->{title})) + scalar(_content_row($self->{content}));

    my $newlines = $height > $text_size ? int(($height - $text_size)/2) : 0;
    return "\n" x $newlines;
}

1;
