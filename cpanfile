requires 'perl', '5.008001';
requires 'Term::ANSIColor', '2.01';
requires 'Class::Accessor::Lite', '0.05';
requires 'Text::VimColor';
requires 'parent';
requires 'Term::ReadKey';
requires 'Unicode::EastAsianWidth', '1.30';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
