package Openponies::Controller::Pony;

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

sub viewPonyById {
    my $self = shift;
    my $id   = shift;

    my $pony = $self->{factory}->getPonyById($id);

    if ($pony ne 0) {
        return $self->viewPony($pony);
    } else {
        return status_not_found({ error => 'Pony not found.' });
    }
}

sub viewPonyByName {
    my $self = shift;
    my $name = shift;

    my $pony = $self->{factory}->getPonyByName($name);

    if ($pony ne 0) {
        return $self->viewPony($pony);
    } else {
        return status_not_found({ error => 'Pony not found.' });
    }
}

sub viewPony {
    my $self = shift;
    my $pony = shift;

    return {
        id          => $pony->getId(),
        name        => $pony->getName(),
        gender      => $pony->getGender(),
        description => $pony->getDescription(),
        appearance  => $pony->getAppearance(),
        created     => $pony->getDtCreatedTimestamp()
    };
}

1;
