package Openponies::Controller::Pony;

use warnings;
use strict;

use Dancer;
use Dancer::Plugin::REST;

sub new {
    my $class          = shift;
    my $factory        = shift;
    my $placeFactory   = shift;
    my $speciesFactory = shift;

    my $self = {
        factory        => $factory,
        placeFactory   => $placeFactory,
        speciesFactory => $speciesFactory
    };

    bless  $self, $class;
    return $self;
}

sub viewPonyById {
    my $self   = shift;
    my $id     = shift;
    my $format = shift;

    my $pony = $self->{factory}->getPonyById($id);

    if ($pony ne 0) {
        return $self->viewPony($pony, $format);
    } else {
        return status_not_found('Pony not found.');
    }
}

sub viewPonyByName {
    my $self   = shift;
    my $name   = shift;
    my $format = shift;

    my $pony = $self->{factory}->getPonyByName($name);

    if ($pony ne 0) {
        return $self->viewPony($pony, $format);
    } else {
        return status_not_found('Pony not found.');
    }
}

sub viewPony {
    my $self   = shift;
    my $pony   = shift;
    my $format = shift;

    return {
        id             => $pony->getId(),
        name           => $pony->getName(),
        gender         => $pony->getGender(),
        description    => $pony->getDescription(),
        appearance     => $pony->getAppearance(),
        created        => $pony->getDtCreatedTimestamp(),
        species        => {
            id   => $pony->getSpeciesId(),
            href => '/species/' . $pony->getSpeciesId() . '.' . $format
        },
        place_birth    => {
            id   => $pony->getPlaceBirthId(),
            href => '/place/' . $pony->getPlaceBirthId() . '.' . $format
        },
        place_home     => {
            id   => $pony->getPlaceHomeId(),
            href => '/place/' . $pony->getPlaceHomeId() . '.' . $format
        }
    };
}

sub createPony {
    my $self         = shift;
    my $name         = shift;
    my $description  = shift;
    my $appearance   = shift;
    my $gender       = shift;
    my $placeBirthId = shift;
    my $placeHomeId  = shift;
    my $speciesId    = shift;
    
    return status_bad_request("That name is already taken.") if ($self->{factory}->getPonyByName($name) ne 0);
    
}

1;
