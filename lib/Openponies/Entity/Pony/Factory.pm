package Openponies::Entity::Pony::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::Pony;

use DateTime;

our @ISA = qw(Openponies::Entity::Abstract::Factory);

sub create {
    my $self = shift;
    my $vars = shift;

    return Openponies::Entity::Pony->new($vars);
}

sub getPonyById {
    my $self = shift;
    my $id   = shift;

    my $data = $self->{gateway}->getPonyById($id);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub getPonyByName {
    my $self = shift;
    my $name = shift;

    my $data = $self->{gateway}->getPonyByName($name);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub createPonyToInsert {
    my $self         = shift;
    my $name         = shift;
    my $description  = shift;
    my $appearance   = shift;
    my $gender       = shift;
    my $placeBirthId = shift;
    my $placeHomeId  = shift;
    my $speciesId    = shift;
    my $userId       = shift;
    my $id           = $self->{gateway}->generateUUID;
    
    my $pony = $self->create({
        id             => $id,
        appearance     => $appearance,
        description    => $description,
        gender         => $gender,
        name           => $name,
        place_birth_id => $placeBirthId,
        place_home_id  => $placeHomeId,
        species_id     => $speciesId,
        dt_created     => DateTime::Format::MySQL->format_datetime(DateTime->now()),
        creator_id     => $userId
    });
    
    return $pony;
}

1;
