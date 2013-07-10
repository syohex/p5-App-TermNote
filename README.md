# NAME

App::TermNote - Application for presentation on terminal

# SYNOPSIS

    % termnote.pl presentation.pl

    # presentation file is just a perl file like below
    [
        {
            type     => 'chapter',
            title    => 'This is Title',
            subtitle => 'This is subtitle',
        },
        {
            type    => 'text',
            title   => 'Why Perl',
            content => 'Hello Perl'
        },
        {
            type     => 'code',
            language => 'perl'
            source   => '...'
    #!perl
    use strict;
    use warnings;

    print "hello\n";
    ...
        },
    ]

# DESCRIPTION

App::TermNote provides presentation on terminal. This is inspired
by Ruby's termnote.

# LICENSE

Copyright (C) Syohei YOSHIDA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Syohei YOSHIDA <syohex@gmail.com>
