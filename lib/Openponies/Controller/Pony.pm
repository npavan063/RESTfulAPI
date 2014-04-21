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

sub allPonies {
    my $self   = shift;
    my $format = shift;
    my $page   = shift;
    my $limit  = shift;
    
    my $poniesList = $self->{factory}->getAllPonies($page, $limit);
    
    if ($poniesList ne 0) {
        my $poniesHashref = {};
        
        foreach my $pony (@{$poniesList}) {
            $poniesHashref->{$pony->getId()} = {
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
        
        return $poniesHashref;
    } else {
        return status_not_found('Ponies not found.');
    }
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
    
    unless (defined $name && defined $description && defined $appearance && defined $gender && defined $placeBirthId && defined $placeHomeId && defined $speciesId &&
            $name ne ''   && $description ne ''   && $appearance ne ''   && $gender ne ''   && $placeBirthId ne ''   && $placeHomeId ne ''   && $speciesId ne '') {
                return status_bad_request('Must send name, description, appearance, gender, place_birth_id, place_home_id & species_id parameters.');
    }
    
    # Name and gender should be title case
    $name   =~ s/(\w+)/\u\L$1/g;
    $gender =~ s/(\w+)/\u\L$1/g;
    
    return status_bad_request("That name is already taken.")
        if ($self->{factory}->getPonyByName($name) ne 0);
    return status_bad_request("Birth place ID $placeBirthId not found.")
        if ($self->{placeFactory}->getPlaceById($placeBirthId) eq 0);
    return status_bad_request("Home place ID $placeHomeId not found.")
        if ($self->{placeFactory}->getPlaceById($placeHomeId) eq 0);
    return status_bad_request("Species ID $speciesId not found.")
        if ($self->{speciesFactory}->getSpeciesById($speciesId) eq 0);
    return status_bad_request("That gender is invalid.")
        if ($gender ne "Male" && $gender ne "Female");
    
    my $pony   = $self->{factory}->createPonyToInsert($name, $description, $appearance, $gender, $placeBirthId, $placeHomeId, $speciesId, vars->{user}->getId());
    my $ponyId = $self->{factory}->{gateway}->createPony($pony);
    
    if ($ponyId ne 0) {
        return status_created({id => $ponyId});
    } else {
        return status_bad_request("Pony could not be created.");
    }
}

sub countPonies {
    my $self   = shift;
    my $format = shift;
    
    my $count = $self->{factory}->{gateway}->countPonies();
    
    if ($count > 0) {
        return {total => $count};
    } else {
        return status_not_found('Not found.');
    }
}

sub deletePony {
    my $self = shift;
    my $pony = shift;
    
    
}

1;
