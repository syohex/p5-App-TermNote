use strict;
use warnings;
use Test::More;

use App::TermNote;
use File::Temp ();

sub create_temp_file {
    my $str = shift;
    my $fh = File::Temp->new(UNLINK => 1);

    print {$fh} $str;
    $fh->autoflush(1);

    return $fh;
}

subtest 'file not found' => sub {
    eval {
        App::TermNote->new("file_not_found.pl");
    };

    like $@, qr/is not found/, "presentation file is not found";
};

subtest "Can't load file" => sub {
    my $tmp = create_temp_file(<<'...');
0;
...

    eval {
        App::TermNote->new($tmp->filename);
    };
    like $@, qr/Can't load/, "Can't load presentation file";
};

subtest "Invalid file format" => sub {
    my $tmp = create_temp_file(<<'...');
+{
    name => 'perl',
};
...

    eval {
        App::TermNote->new($tmp->filename);
    };
    like $@, qr/presentation file should return ArrayRef/, "Can't load presentation file";
};

subtest "valid file format" => sub {
    my $tmp = create_temp_file(<<'...');
+[
    {
        type     => 'chapter',
        title    => 'Test',
        subtitle => 'This is a test presentation',
    },
    {
        type    => 'text',
        title   => 'Test Text',
        content => 'This is test!!',
    },
];
...

    my $app = App::TermNote->new($tmp->filename);
    ok $app;
    isa_ok $app, 'App::TermNote';
    is scalar(@{$app->{panes}}), 2;

    isa_ok $app->{panes}->[0], "App::TermNote::Pane::Chapter";
    isa_ok $app->{panes}->[1], "App::TermNote::Pane::Text";
};

done_testing;
