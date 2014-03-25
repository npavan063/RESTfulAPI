package Openponies::Entity::Pony::Gateway;

use warnings;
use strict;

use Openponies::Entity::Abstract::Gateway;
our @ISA = qw(Openponies::Entity::Abstract::Gateway);

sub getPonyById {
    my $self = shift;
    my $id   = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `ponies` WHERE `id` = ? LIMIT 1;");
    $query->execute($id);

    $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub getPonyByName {
    my $self = shift;
    my $name = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `ponies` WHERE `name` = ? LIMIT 1;");
    $query->execute($name);

    $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

1;
