package Openponies::Entity::Place::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::Place;

use DateTime;

our @ISA = qw(Openponies::Entity::Abstract::Factory);

sub create {
    my $self = shift;
    my $vars = shift;

    return Openponies::Entity::Place->new($vars);
}

sub getPlaceById {
    my $self = shift;
    my $id   = shift;

    my $data = $self->{gateway}->getPlaceById($id);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub getPlaceByName {
    my $self = shift;
    my $name = shift;

    my $data = $self->{gateway}->getPlaceByName($name);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub getAllPlaces {
    my $self = shift;
    
    my $data = $self->{gateway}->getAllPlaces();
    
    if ($data ne 0) {
        my @places = ();
        
        foreach my $row (@{$data}) {
            push(@places, $self->create($row));
        }
        
        return \@places;
    } else {
        return 0;
    }
}

sub createPlaceToInsert {
    my $self        = shift;
    my $name        = shift;
    my $description = shift;
    my $userId      = shift;
    my $id          = $self->{gateway}->generateUUID;
    
    my $place = $self->create({
        id          => $id,
        name        => $name,
        description => $description,
        creator_id  => $userId,
        dt_created  => DateTime::Format::MySQL->format_datetime(DateTime->now())
    });
    
    return $place;
}

1;
