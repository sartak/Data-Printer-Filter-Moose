package Data::Printer::Filter::Moose;
use strict;
use warnings;

use Data::Printer ();
use Term::ANSIColor qw(colored);
use Data::Printer::Filter;
use Class::MOP;

my $BREAK = "\n"; # XXX use $Data::Printer::BREAK instead

filter "-class" => sub {
    my ($object, $p) = @_;

    my $meta = Class::MOP::class_of($object);
    unless ($meta && $meta->isa('Moose::Meta::Class')) {
        return Data::Printer::_class(@_);
    }

    my $output = '';
    $p->{class}{_depth}++;

    $output .= colored($meta->name, $p->{color}->{'class'});

    if ( $p->{class}{show_reftype} ) {
        $output .= ' (' . colored(
            Scalar::Util::reftype($object),
            $p->{color}->{'class'}
        ) . ')';
    }

    if ($p->{class}{expand} eq 'all'
        or $p->{class}{expand} >= $p->{class}{_depth}
    ) {
        $output .= "  {$BREAK";
        $p->{_current_indent} += $p->{indent};

        $output .= _dump_moose_inheritance($meta, $p);
        $output .= _dump_moose_roles($meta, $p);

        $p->{_current_indent} -= $p->{indent};
        $output .= (' ' x $p->{_current_indent}) . "}";
    }

    $p->{class}{_depth}--;

    return $output;
};

sub _dump_moose_inheritance {
    my ($meta, $p) = @_;
    my $output = '';

    if ( my @superclasses = $meta->superclasses ) {
        if ($p->{class}{parents}) {
            $output .= (' ' x $p->{_current_indent})
                    . 'Parents          '
                    . join(', ', map { colored($_, $p->{color}->{'class'}) }
                                    @superclasses
                    ) . $BREAK;
        }

        if ($p->{class}{linear_isa}) {
            $output .= (' ' x $p->{_current_indent})
                    . 'Linear @ISA      '
                    . join(', ', map { colored( $_, $p->{color}->{'class'}) }
                                $meta->linearized_isa
                    ) . $BREAK;
        }
    }

    return $output;
}

sub _dump_moose_roles {
    my ($meta, $p) = @_;
    my $output = '';

    my @all_roles = $meta->calculate_all_roles_with_inheritance;

    my @local_roles = $meta->calculate_all_roles;

    # composite roles are hard to read and don't really add much, so they can be default off
    unless ($p->{class}{composite_roles}) {
        @all_roles   = grep { !$_->isa('Moose::Meta::Role::Composite') } @all_roles;
        @local_roles = grep { !$_->isa('Moose::Meta::Role::Composite') } @local_roles;
    }

    my %is_local = map { $_->name => 1 } @local_roles;
    my @inherited_roles = grep { !$is_local{ $_->name } } @all_roles;

    if (@all_roles) {
        if (1 || $p->{class}{roles}) { # XXX can't inject more default config
            if (1 || $p->{class}{local_roles}) {
                $output .= (' ' x $p->{_current_indent})
                        . 'Local Roles      '
                        . join(', ', map { colored($_->name, $p->{color}->{'role'}) }
                                        @local_roles
                        ) . $BREAK;
            }

            if (1 || $p->{class}{inherited_roles}) {
                $output .= (' ' x $p->{_current_indent})
                        . 'Inherited Roles  '
                        . join(', ', map { colored($_->name, $p->{color}->{'role'}) }
                                        @inherited_roles
                        ) . $BREAK;
            }
        }
    }

    return $output;
}

1;

