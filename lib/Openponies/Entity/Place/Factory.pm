package Openponies::Entity::Place::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::Place;

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

1;
