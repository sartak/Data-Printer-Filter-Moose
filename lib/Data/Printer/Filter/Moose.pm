package Data::Printer::Filter::Moose;
use strict;
use warnings;

use Data::Printer ();
use Data::Printer::Filter;
use Class::MOP;

filter "-class" => sub {
    my ($obj, $p) = @_;

    if ($obj->isa('Moose::Object')) {
        return _dump_moose_object($obj, $p);
    }
    else {
        return Data::Printer::_class(@_);
    }
};

sub _dump_moose_object {
    my ($obj, $p) = @_;

    my $meta = Class::MOP::class_of($obj);
    return $meta->name;
}

1;

