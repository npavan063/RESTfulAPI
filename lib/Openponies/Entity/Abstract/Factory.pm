package Openponies::Entity::Abstract::Factory;

use warnings;
use strict;

sub new {
    my $class   = shift;
    my $gateway = shift;

    my $self = {
        gateway => $gateway
    };

    bless  $self, $class;
    return $self;
}

1;
