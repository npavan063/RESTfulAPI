package Openponies::Entity::User::Gateway;

use warnings;
use strict;

use Openponies::Entity::Abstract::Gateway;
our @ISA = qw(Openponies::Entity::Abstract::Gateway);

use constant ERROR_USERNAME_EXISTS => -1;
use constant ERROR_EMAIL_EXISTS    => -2;
use constant ERROR_ID_EXISTS       => -3;

sub getUser {
    my $self  = shift;
    my $field = shift;
    my $value = shift;

    my $query = $self->{dbHandle}->prepare("SELECT * FROM `users` WHERE `".$field."` = ? LIMIT 1;");
    $query->execute($value);

    my $data = $query->fetchrow_hashref;

    if (defined $data) {
        return $data;
    } else {
        return 0;
    }
}

sub getUserByAuth {
    my $self     = shift;
    my $username = shift;

    return $self->getUser('login', $username);    
}

sub registerUser {
    my $self = shift;
    my $user = shift;
    
    my $userByName = $self->getUser('login', $user->getUsername());
    return $self->ERROR_USERNAME_EXISTS if ($userByName ne 0);
    
    my $userByEmail = $self->getUser('email_address', $user->getEmailAddress());
    return $self->ERROR_EMAIL_EXISTS if ($userByEmail ne 0);
    
    my $query = $self->{dbHandle}->prepare("INSERT INTO `users` (`id`, `login`, `password`, `email_address`, `roles`, `name`)
                                            VALUES              (?,    ?,       ?,          ?,               ?,       ?);");
    my $result = $query->execute($user->getId(), $user->getUsername(), $user->getPasswordHash(), $user->getEmailAddress(), $user->getRoles(), $user->getName());
    
    if ($result eq 1) {
        return $user->getId();
    } else {
        return 0;
    }
}

1;
