package Openponies::Entity::Pony::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::Pony;

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

1;
