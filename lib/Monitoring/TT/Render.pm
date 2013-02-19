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
    return join_hash_list(@_) if defined $_[0] and ref $_[0] eq 'HASH';
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

=head2 join_hash_list

    join_hash_list($hashlist, $exceptions)

    returns list csv list for hash but leave out exceptions

=cut
sub join_hash_list {
    my($hash, $exceptions) = @_;
    return "" unless defined $hash;
    my $list  = [];
    for my $key (sort keys %{$hash}) {
        my $skip = 0;
        for my $ex (@{_list($exceptions)}) {
            if($key =~ m/$ex/mx) {
                $skip = 1;
                last;
            }
        }
        next if $skip;
        for my $val (@{_list($hash->{$key})}) {
            if($val) {
                push @{$list}, $key.'='.$val;
            } else {
                push @{$list}, $key;
            }
        }
    }
    return join(', ', @{$list});
}

#####################################################################
sub _list {
    my($data) = @_;
    return([]) unless defined $data;
    return($data) if ref $data eq 'ARRAY';
    return([$data]);
}
#####################################################################

=head1 AUTHOR

Sven Nierlein, 2013, <sven.nierlein@consol.de>

=cut

1;
