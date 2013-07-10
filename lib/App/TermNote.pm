package App::TermNote;
use 5.008005;
use strict;
use warnings;

use Carp ();
use Module::Load ();
use Term::ReadKey ();

our $VERSION = "0.01";

sub new {
    my ($class, $file) = @_;

    Carp::croak("$file is not found") unless -e $file;

    my $documents = do $file or Carp::croak("Can't load $file. $!");
    unless (ref $documents eq "ARRAY") {
        Carp::croak("presentation file should return ArrayRef");
    }

    my @panes;
    for my $document (@{$documents}) {
        Carp::croak("Not found 'type' parameter") unless exists $document->{type};
        my $class = "App::TermNote::Pane::" . ucfirst $document->{type};
        eval {
            Module::Load::load($class);
        };
        if ($@) {
            Carp::croak("Not supported type: '$document->{type}'($!)");
        }

        push @panes, $class->new($document);
    }

    bless {
        panes => \@panes,
    }, $class;
}

sub run {
    my $self = shift;

    $self->{current_index} = 0;
    $self->{state} = 1;
    while ($self->{state}) {
        my $pane = $self->{panes}->[ $self->{current_index} ];
        my ($width, $height) = Term::ReadKey::GetTerminalSize();
        my $spaces = "\n" x (int($height / 2) - 2);

        my $header_str = sprintf "[%d/%d]",
            $self->{current_index}+1, scalar(@{$self->{panes}});

        my $is_forward = $pane->render($width, $height, $header_str);
        if ($is_forward) {
            $self->_forward;
            next;
        }

        $self->_capture_command;
    }
}

sub _forward {
    my $self = shift;
    my $pane_num = scalar(@{$self->{panes}});

    $self->{current_index} = ($self->{current_index} + 1) % $pane_num;
}

sub _backward {
    my $self = shift;
    my $pane_num = scalar(@{$self->{panes}});
    my $next = $self->{current_index} - 1;
    $next += $pane_num if $next < 0;

    $self->{current_index} = $next;
}

sub _close {
    my $self = shift;
    $self->{state} = 0;
}

my %cmd_table = (
    "j" => sub { $_[0]->_forward; },
    "k" => sub { $_[0]->_backward; },
    "q" => sub { $_[0]->_close; },
);

sub _capture_command {
    my $self = shift;

    Term::ReadKey::ReadMode 4;

    my $cmd = getc;
    if (exists $cmd_table{$cmd}) {
        $cmd_table{$cmd}->($self);
    }

    Term::ReadKey::ReadMode 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

App::TermNote - Application for presentation on terminal

=head1 SYNOPSIS

    % termnote.pl presentation.pl

    # presentation file is just a perl file like below
    {
        type     => 'chapter',
        title    => 'How To Learn',
        subtitle => 'A Presentation By Tms',
    },
    {
        type    => 'text',
        title   => 'Find Inspiration',
        content => <<'...'
Anyone who stops learning is old,  whether
at twenty or eighty. Anyone who keeps
learning stays young. The greatest
thing in life is to keep your mind
young.

-- Henry Ford
...
    },
    {
        type     => 'code',
        language => 'ruby',
        source   => <<'...'
# Some random code here
puts 'Hello, world!'
name + nom
function(full)
class Foo < Far
  :sum
end
...
    },

=head1 DESCRIPTION

App::TermNote provides presentation on terminal. This is inspired
by Ruby's termnote.

=head1 LICENSE

Copyright (C) Syohei YOSHIDA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=cut
