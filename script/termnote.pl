#!perl
use strict;
use warnings;

use App::TermNote;

my $file = shift or die "Usage: $0 file";
my $app = App::TermNote->new($file);
$app->run;
