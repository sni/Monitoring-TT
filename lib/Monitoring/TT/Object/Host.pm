package Monitoring::TT::Object::Host;

use strict;
use warnings;
use utf8;
use base 'Monitoring::TT::Object';

#####################################################################

=head1 NAME

Monitoring::TT::Object::Host - Object representation of a host

=head1 DESCRIPTION

contains generic methods which can be used in templates for each object

=cut

#####################################################################

=head1 METHODS

=head2 BUILD

return new object

=cut
sub BUILD {
    my($class, $self) = @_;
    bless $self, $class;
    return $self;
}

#####################################################################

=head2 has_app

returns true if object has specific app, false otherwise.

=cut
sub has_app {
    my( $self, $app, $val ) = @_;
    return $self->_has_something('extra_apps', $app, $val) || $self->_has_something('apps', $app, $val);
}

#####################################################################

=head2 apps

returns list of apps or empty list otherwise

=cut
sub apps {
    my( $self ) = @_;
    return $self->{'apps'} if exists $self->{'apps'};
    return [];
}

#####################################################################

=head2 extra_apps

returns list of extra apps or empty list otherwise

=cut
sub extra_apps {
    my( $self ) = @_;
    return $self->{'extra_apps'} if exists $self->{'extra_apps'};
    return [];
}

#####################################################################

=head2 set_app

set additional app

=cut
sub set_app {
    my( $self, $app, $val ) = @_;
    return $self->_set_something('extra_apps', $app, $val);
}

#####################################################################

=head1 AUTHOR

Sven Nierlein, 2013, <sven.nierlein@consol.de>

=cut

1;
