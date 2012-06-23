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
    package Role::HasName;
    use Moose::Role;

    has name => (
        is  => 'ro',
        isa => 'Str',
    );
};

do {
    package Role::HasHeight;
    use Moose::Role;

    has height => (
        is  => 'ro',
        isa => 'Int',
    );
};

do {
    package Role::HasWidth;
    use Moose::Role;

    has width => (
        is  => 'ro',
        isa => 'Int',
    );
};

do {
    package Role::IsPhysicalThing;
    use Moose::Role;

    with 'Role::HasHeight',
         'Role::HasWidth';
};

do {
    package My::Moosey::Person;
    use Moose;

    with 'Role::HasName';
};

do {
    package My::Moosey::RealPerson;
    use Moose;
    extends 'My::Moosey::Person';

    with 'Role::IsPhysicalThing';
};

my $superclass = My::Moosey::Person->new;
my $dump = p($superclass);
diag $dump;

like($dump, qr/My::Moosey::Person/, 'dump contains class name');
like($dump, qr/Role::HasName/, 'dump contains role name');

my $subclass = My::Moosey::RealPerson->new;
$dump = p($subclass);
diag $dump;

like($dump, qr/My::Moosey::RealPerson/, 'dump contains class name');
like($dump, qr/My::Moosey::Person/, 'dump contains superclass name');
like($dump, qr/Role::IsPhysicalThing/, 'dump contains directly consumed role name');
like($dump, qr/Role::HasHeight/, 'dump contains indirectly consumed role name');
like($dump, qr/Role::HasWidth/, 'dump contains indirectly consumed role name');
like($dump, qr/Role::HasName/, 'dump contains inherited role name');

done_testing;

