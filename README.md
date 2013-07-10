# NAME

App::TermNote - Application for presentation on terminal

# SYNOPSIS

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

\-- Henry Ford
...
    },
    {
        type     => 'code',
        language => 'ruby',
        source   => <<'...'
\# Some random code here
puts 'Hello, world!'
name + nom
function(full)
class Foo < Far
  :sum
end
...
    },

# DESCRIPTION

App::TermNote provides presentation on terminal. This is inspired
by Ruby's termnote.

# LICENSE

Copyright (C) Syohei YOSHIDA.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Syohei YOSHIDA <syohex@gmail.com>
