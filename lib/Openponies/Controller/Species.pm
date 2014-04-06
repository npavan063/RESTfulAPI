package Openponies::Controller::Species;

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

sub viewSpeciesById {
    my $self = shift;
    my $id   = shift;

    my $species = $self->{factory}->getSpeciesById($id);

    if ($species ne 0) {
        return $self->viewSpecies($species);
    } else {
        return status_not_found('Species not found.');
    }
}

sub viewSpecies {
    my $self    = shift;
    my $species = shift;

    return {
        id          => $species->getId(),
        name        => $species->getName(),
        description => $species->getDescription()
    };
}

sub allSpecies {
    my $self   = shift;
    my $format = shift;
    
    my $speciesList = $self->{factory}->getAllSpecies();
    
    if ($speciesList ne 0) {
        my $speciesHashref = {};
        foreach my $species (@{$speciesList}) {
            $speciesHashref->{$species->getId()} = {
                id          => $species->getId(),
                name        => $species->getName(),
                description => $species->getDescription()
            };
        }
        return $speciesHashref;
    } else {
        return status_not_found('Species not found.');
    }
}

1;
