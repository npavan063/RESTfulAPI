package Openponies::Entity::User::Gateway;

use warnings;
use strict;

use Openponies::Entity::Abstract::Gateway;
our @ISA = qw(Openponies::Entity::Abstract::Gateway);

sub getUserByAuth {
    my $self     = shift;
    my $username = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `users` WHERE `login` = ? LIMIT 1;");
    $query->execute($username);

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

1;
