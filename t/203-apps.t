use strict;
use warnings;
use Test::More;

eval "use Test::Cmd";
plan skip_all => 'Test::Cmd required' if $@;
plan tests    => 13;

use lib('t');
use TestUtils;

TestUtils::test_montt('t/data/203-apps', {
        errlike => [
            '/unsued type \'linux\' defined in/',
            '/unsued tag \'contact_groups\' defined/',
        ],
    }
);
