use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{ANSI_COLORS_DISABLED} = 1;
    use File::HomeDir::Test;  # avoid user's .dataprinter
};

use Data::Printer {
    filters => {
        -external => 'Moose',
    },
};

do {
    package My::Moosey::Person;
    use Moose;

    has first_name => (
        is       => 'ro',
        isa      => 'Str',
        required => 1,
    );

    has last_name => (
        is  => 'ro',
        isa => 'Str',
    );
};

my $obj = My::Moosey::Person->new(first_name => 'Madonna');
my $dump = p($obj);
diag $dump;

like($dump, qr/My::Moosey::Person/, 'dump contains class name');
like($dump, qr/first_name/, 'dump contains attribute first_name');
like($dump, qr/last_name/, 'dump contains attribute last_name');
like($dump, qr/Madonna/, 'dump contains value of attribute first_name');

$dump = p($obj, class => { show_reftype => 1 });
like($dump, qr/My::Moosey::Person \(HASH\)/, 'dump contains class name and reftype');

done_testing;
