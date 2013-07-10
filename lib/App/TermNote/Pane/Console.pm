package App::TermNote::Pane::Console;
use strict;
use warnings;

use parent qw/App::TermNote::Pane/;

sub new {
    my ($class, $document) = @_;

    bless {
        binary => $document->{binary},
    }, $class;
}

sub render {
    my $self = shift;
    system $self->{binary};
    return 1;
}

1;
