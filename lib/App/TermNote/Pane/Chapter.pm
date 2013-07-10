package App::TermNote::Pane::Chapter;
use strict;
use warnings;

use parent qw/App::TermNote::Pane/;

use App::TermNote::Util qw/wrapped_title wrap_bold/;

sub new {
    my ($class, $document) = @_;

    bless {
        title    => $document->{title},
        subtitle => $document->{subtitle},
    }, $class;
}

sub rows {
    my $self = shift;

    my @ret = wrap_bold(wrapped_title($self->{title}));
    if ($self->{subtitle}) {
        push @ret, wrapped_title($self->{subtitle})
    }

    return @ret;
}

1;
