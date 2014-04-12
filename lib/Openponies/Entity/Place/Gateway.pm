package Openponies::Entity::Place::Gateway;

use warnings;
use strict;

use Openponies::Entity::Abstract::Gateway;
our @ISA = qw(Openponies::Entity::Abstract::Gateway);

sub getPlaceById {
    my $self = shift;
    my $id   = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `places` WHERE `id` = ? LIMIT 1;");
    $query->execute($id);

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub getPlaceByName {
    my $self = shift;
    my $name = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `places` WHERE `name` = ? LIMIT 1;");
    $query->execute($name);

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub getAllPlaces {
    my $self = shift;
    
    my $query = $self->{dbHandle}->prepare("SELECT * FROM `places` ORDER BY `name` ASC;");
    $query->execute();
    
    my $data = $query->fetchall_arrayref({});
    
    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub createPlace {
    my $self  = shift;
    my $place = shift;
    
    my $query = $self->{dbHandle}->prepare("INSERT INTO `places` (`id`, `name`, `description`, `dt_created`, `creator_id`)
                                            VALUES               (?,    ?,      ?,             ?,            ?);");
    
    my $result = $query->execute(
        $place->getId(),
        $place->getName(),
        $place->getDescription(),
        $place->getDtCreated(),
        $place->getCreatorId()
    );
    
    if ($result eq 1) {
        return $place->getId();
    } else {
        return 0;
    }
}

1;
