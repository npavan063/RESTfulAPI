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
        return status_not_found('Place not found.');
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

sub allPlaces {
    my $self   = shift;
    my $format = shift;
    
    my $placesList = $self->{factory}->getAllPlaces();
    
    if ($placesList ne 0) {
        my $placesHashref = {};
        
        foreach my $place (@{$placesList}) {
            $placesHashref->{$place->getId()} = {
                id          => $place->getId(),
                name        => $place->getName(),
                description => $place->getDescription()
            };
        }
        
        return $placesHashref;
    } else {
        return status_not_found('Places not found.');
    }
}

sub createPlace {
    my $self        = shift;
    my $name        = shift;
    my $description = shift;
    
    $name   =~ s/(\w+)/\u\L$1/g;
    
    unless (defined $name && defined $description &&
            $name ne ''   && $description ne '') {
        return status_bad_request('Must send name & description.');
    }
    
    return status_bad_request('That name is already taken.')
        if ($self->{factory}->getPlaceByName($name));
    
    my $place   = $self->{factory}->createPlaceToInsert($name, $description, vars->{user}->getId());
    my $placeId = $self->{factory}->{gateway}->createPlace($place);
    
    if ($placeId ne 0) {
        return status_created({id => $placeId});
    } else {
        return status_bad_request("Place could not be created.");
    }
}

1;
