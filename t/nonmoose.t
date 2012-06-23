use strict;
use warnings;
use Test::More;

BEGIN {
    $ENV{ANSI_COLORS_DISABLED} = 1;
    use File::HomeDir::Test;  # avoid user's .dataprinter
};

use Data::Printer {
    alias => 'with_moose',
    filters => {
        -external => 'Moose',
    },
};

use Data::Printer {
    alias => 'without_moose',
};

package My::Module;
sub new { bless {}, shift }
sub test { return 'this is a test' }

package Other::Module;
sub new { bless {}, shift }

package main;

my $obj = My::Module->new;

is(with_moose($obj), without_moose($obj), "Moose defaults to Data::Printer's defaults");
is with_moose($obj, filters => { 'My::Module' => sub { return 'mo' }}), 'mo', 'overriding My::Module filter';
is with_moose($obj, filters => { 'My::Module' => sub { return } }), without_moose($obj), 'filter override with fallback';

my $obj2 = Other::Module->new;
is(with_moose($obj2), without_moose($obj2), "Moose defaults to Data::Printer's defaults");

is with_moose($obj2, filters => { 'Other::Module' => sub { return } }), without_moose($obj2),
   '-class filters can have a go if specific filter failed';

done_testing;
