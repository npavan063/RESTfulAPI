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

1;
