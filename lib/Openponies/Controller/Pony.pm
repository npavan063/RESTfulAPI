package Openponies::Controller::Pony;

use warnings;
use strict;

sub new {
    my $class   = shift;
    my $factory = shift;

    my $self = {
        factory => $factory
    };

    bless  $self, $class;
    return $self;
}

sub viewPonyById {
    my $class = shift;
    my $id    = shift;

    return {success => $id};
}

sub viewPonyByName {
    my $class = shift;
    my $name  = shift;

    return {success => $name};
}

1;
