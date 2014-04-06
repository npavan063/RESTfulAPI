package Openponies::Entity::Species::Gateway;

use warnings;
use strict;

use Openponies::Entity::Abstract::Gateway;
our @ISA = qw(Openponies::Entity::Abstract::Gateway);

sub getSpeciesById {
    my $self = shift;
    my $id   = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `species` WHERE `id` = ? LIMIT 1;");
    $query->execute($id);

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub getAllSpecies {
    my $self = shift;
    
    my $query = $self->{dbHandle}->prepare("SELECT * FROM `species` ORDER BY `name` ASC;");
    $query->execute();
    
    my $data = $query->fetchall_arrayref({});
    
    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

1;
