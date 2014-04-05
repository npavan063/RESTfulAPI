package Openponies::Entity::User::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::User;

our @ISA = qw(Openponies::Entity::Abstract::Factory);

sub create {
    my $self = shift;
    my $vars = shift;

    return Openponies::Entity::User->new($vars);
}

sub getUserByAuth {
    my $self     = shift;
    my $username = shift;
    my $password = shift;

    my $data = $self->{gateway}->getUserByAuth($username, $password);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub createUserForRegistration {
    my $self     = shift;
    my $username = shift;
    my $password = shift;
    my $email    = shift;  
    my $id       = $self->{gateway}->generateUUID;
    
    my $user = $self->create({
        id            => $id,
        login         => $username,
        password      => $password,
        email_address => $email,
        roles         => "user",
        name          => "Anonymous"
    });
    
    return $user;
}

1;
