package Openponies::Controller::User;

use warnings;
use strict;

use Dancer;
use Dancer::Plugin::REST;

use Crypt::SaltedHash;
use Digest::PBKDF2;

sub new {
    my $class   = shift;
    my $factory = shift;

    my $self = {
        factory => $factory
    };

    bless  $self, $class;
    return $self;
}

sub authenticate {
    my $self     = shift;
    my $username = shift;
    my $password = shift;
    my $user     = 0;

    my $result = $self->{factory}->getUserByAuth($username);

    if (Crypt::SaltedHash->validate($result->getPasswordHash(), $password)) {
        $user = $result;
    }

    return $user;
}

1;
