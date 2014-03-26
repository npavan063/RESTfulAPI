package Openponies::Controller::Place;

use warnings;
use strict;

use Dancer;
use Dancer::Plugin::REST;

sub new {
    my $class   = shift;
    my $factory = shift;

    my $self = {
        factory => $factory
    };

    bless  $self, $class;
    return $self;
}

sub viewPlaceById {
    my $self = shift;
    my $id   = shift;

    my $place = $self->{factory}->getPlaceById($id);

    if ($place ne 0) {
        return $self->viewPlace($place);
    } else {
        return status_not_found({ error => 'Place not found.' });
    }
}

sub viewPlace {
    my $self  = shift;
    my $place = shift;

    return {
        id          => $place->getId(),
        name        => $place->getName(),
        description => $place->getDescription()
    };
}

1;
