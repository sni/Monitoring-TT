use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 3;

use_ok('Monitoring::TT');
use_ok('Monitoring::TT::Input::CSV');

my $csv       = Monitoring::TT::Input::CSV->new();
my $types     = $csv->get_types(['t/data/110-input_csv']);
my $types_exp = ['hosts'];

is_deeply($types, $types_exp, 'nagios input types') or diag(Dumper($types));
