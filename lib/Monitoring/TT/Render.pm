package Monitoring::TT::Render;

use strict;
use warnings;
use utf8;
use Carp;
use Monitoring::TT::Log qw/error warn info debug trace log/;

#####################################################################

=head1 NAME

Monitoring::TT::Render - Render Helper Functions

=head1 DESCRIPTION

All functions from this render helper can be used in templates

=cut

#####################################################################

=head1 METHODS

=head2 die

    die(error message)

    die with an hopefully useful error message

=cut
sub die {
    my( $msg ) = @_;
    croak($msg);
    return;
}

#####################################################################

=head2 uniq

    uniq(objects, attr)
    uniq(objects, attr, name)

    returns list of uniq values for one attr of a list of objects

    ex.:

    get uniq list of group items
    uniq(hosts, 'group')

    get uniq list of test tags
    uniq(hosts, 'tag', 'test')

=cut
sub uniq {
    my( $objects, $attr , $name ) = @_;
    croak('expected list of objects') unless ref $objects eq 'ARRAY';
    my $uniq = {};
    for my $o (@{$objects}) {
        if($name) {
            next unless defined $o->{$attr};
            next unless defined $o->{$attr}->{$name};
            for my $v (split('\|', $o->{$attr}->{$name})) {
                $uniq->{$v} = 1;
            }
        } else {
            for my $a (@{$o->{$attr}}) {
                $uniq->{$a} = 1;
            }
        }
    }
    my @list = keys %{$uniq};
    return \@list;
}

#####################################################################

=head2 join_list

    join_list(list1, list2, ...)

    returns list of uniq values in all lists

=cut
sub join_list {
    my $uniq = {};
    for my $list (@_) {
        for my $i (@{$list}) {
            $uniq->{$i} = 1;
        }
    }
    my @items = keys %{$uniq};
    return \@items;
}

#####################################################################

=head1 AUTHOR

Sven Nierlein, 2013, <sven.nierlein@consol.de>

=cut

1;
