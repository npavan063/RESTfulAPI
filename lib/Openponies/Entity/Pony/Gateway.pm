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

    my $data = $query->fetchrow_hashref;

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

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub createPony {
    my $self = shift;
    my $pony = shift;
    
    my $query = $self->{dbHandle}->prepare("INSERT INTO `ponies` (`id`, `name`, `appearance`, `description`, `gender`, `place_birth_id`, `place_home_id`, `species_id`, `dt_created`, `creator_id`)
                                            VALUES               (?,    ?,      ?,            ?,             ?,        ?,                ?,               ?,            ?,            ?);");
    
    my $result = $query->execute(
        $pony->getId(),
        $pony->getName(),
        $pony->getAppearance(),
        $pony->getDescription(),
        $pony->getGender(),
        $pony->getPlaceBirthId(),
        $pony->getPlaceHomeId(),
        $pony->getSpeciesId(),
        $pony->getDtCreated(),
        $pony->getCreatorId()
    );
    
    if ($result eq 1) {
        return $pony->getId();
    } else {
        return 0;
    }
}

sub getAllPonies {
    my $self  = shift;
    my $page  = shift;
    my $limit = shift;
    
    $limit     = 50 if ($limit =~ m/\D/ || $limit > 50);
    $page      = 1  if ($page  =~ m/\D/);
    my $offset = 1 + (($page - 1) * $limit);
    
    my $query = $self->{dbHandle}->prepare("SELECT * FROM `ponies` ORDER BY `name` ASC LIMIT $limit OFFSET $offset;");
    $query->execute();
    
    my $data = $query->fetchall_arrayref({});
    
    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

1;
