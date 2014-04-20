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

sub deleteUserByUsername {
    my $self     = shift;
    my $username = shift;
    
    my $query  = $self->{dbHandle}->prepare("DELETE FROM `users` WHERE `login` = ? LIMIT 1;");
    my $result = $query->execute($username);
    
    if ($result eq 1) {
        return 1;
    } else {
        return 0;
    }
}

sub updatePassword {
    my $self     = shift;
    my $username = shift;
    my $password = shift;
    
    my $query  = $self->{dbHandle}->prepare("UPDATE `users` SET `password` = ? WHERE `login` = ? LIMIT 1;");
    my $result = $query->execute($password, $username);
    
    if ($result eq 1) {
        return 1;
    } else {
        return 0;
    }
}

sub setLastLogin {
    my $self      = shift;
    my $username  = shift;
    my $lastLogin = shift;
    
    my $query  = $self->{dbHandle}->prepare("UPDATE `users` SET `last_login` = ? WHERE `login` = ? LIMIT 1;");
    my $result = $query->execute($lastLogin, $username);
    
    if ($result eq 1) {
        return 1;
    } else {
        return 0;
    }
}

sub setResetToken {
    my $self     = shift;
    my $username = shift;
    my $token    = shift;
    my $expiry   = shift;
    
    my $query  = $self->{dbHandle}->prepare("UPDATE `users` SET `reset_token` = ?, `reset_token_expiry` = ? WHERE `login` = ? LIMIT 1;");
    my $result = $query->execute($token, $expiry, $username);
    
    if ($result eq 1) {
        return 1;
    } else {
        return 0;
    }
}

sub expireResetToken {
    my $self     = shift;
    my $username = shift;
    
    my $query  = $self->{dbHandle}->prepare("UPDATE `users` SET `reset_token_expiry` = '1970-01-01 00:00:01' WHERE `login` = ? LIMIT 1;");
    my $result = $query->execute($username);
    
    if ($result eq 1) {
        return 1;
    } else {
        return 0;
    }   
}

1;
