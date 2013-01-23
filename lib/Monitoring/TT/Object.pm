package Monitoring::TT::Object;

use strict;
use warnings;
use utf8;
use Monitoring::TT::Object::Contact;
use Monitoring::TT::Object::Host;

#####################################################################

=head1 NAME

Monitoring::TT::Object - Object representation of a data item

=head1 DESCRIPTION

contains generic methods which can be used in templates for each object

=cut

#####################################################################

=head1 CONSTRUCTOR

=head2 new

returns new object

=cut
sub new {
    my( $class, $type, $data ) = @_;
    $type = substr($type, 0, -1);
    my $objclass = 'Monitoring::TT::Object::'.ucfirst($type);
    my $obj      = \&{$objclass."::BUILD"};
    die("no such type: $type") unless defined &$obj;
    my $current_object = &$obj($objclass, $data);
    return $current_object;
}

#####################################################################

=head1 METHODS

=head2 has_tag

returns true if object has specific tag, false otherwise.

=cut
sub has_tag {
    my( $self, $tag, $val ) = @_;
    return $self->_has_something('tags', $tag, $val);
}

#####################################################################

=head2 tags

returns list of tags or empty list otherwise

=cut
sub tags {
    my( $self ) = @_;
    return $self->{'tags'} if exists $self->{'tags'};
    return [];
}

#####################################################################

=head2 tag

returns value of this tag or empty string if not set

=cut
sub tag {
    my( $self, $tag ) = @_;
    $tag = lc $tag;
    return "" unless defined $self->{'tags'}->{$tag};
    return $self->{'tags'}->{$tag};
}

#####################################################################

=head2 set_tag

set additional tag

=cut
sub set_tag {
    my( $self, $tag, $val ) = @_;
    return $self->_set_something('tags', $tag, $val);
}

#####################################################################
# INTERNAL SUBS
#####################################################################
sub _has_something {
    my( $self, $type, $tag, $val ) = @_;
    $tag = lc $tag;
    if(defined $val) {
        if(ref $self->{$type}->{$tag} eq 'ARRAY') {
            for my $a (@{$self->{$type}->{$tag}}) {
                return 1 if lc($a) eq lc($val);
            }
        } else {
            return 1 if lc($self->{$type}->{$tag}) eq lc($val);
        }
    } else {
        return 1 if exists $self->{$type}->{$tag};
    }
    return 0;
}

#####################################################################
sub _set_something {
    my( $self, $type, $tag, $val ) = @_;
    $tag = lc $tag;
    $val = "" unless defined $val;
    $self->{$type}->{$tag} = [] unless defined $self->{$type}->{$tag};
    if(ref $self->{$type}->{$tag} ne 'ARRAY') {
        $self->{$type}->{$tag} = Monitoring::TT::Utils::get_uniq_sorted([$self->{$type}->{$tag}, $val]);
    } else {
        $self->{$type}->{$tag} = Monitoring::TT::Utils::get_uniq_sorted([@{$self->{$type}->{$tag}}, $val]);
    }
    return "";
}

#####################################################################

=head1 AUTHOR

Sven Nierlein, 2013, <sven.nierlein@consol.de>

=cut

1;
