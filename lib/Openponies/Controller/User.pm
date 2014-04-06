package Openponies::Controller::User;

use warnings;
use strict;

use Openponies;

use Dancer;
use Dancer::Plugin::REST;

use Crypt::SaltedHash;
use Digest::PBKDF2;
use Mail::RFC822::Address qw(valid);

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
    
    print Dumper $result;
    print "\n\n\n\n";

    unless ($result eq 0) {
        if (Crypt::SaltedHash->validate($result->getPasswordHash(), $password)) {
            $user = $result;
        }
    }

    return $user;
}

sub successfulLogin {
    my $self = shift;
    
    return {'id' => vars->{user}->getId()};
}

sub register {
    my $self     = shift;
    my $username = shift;
    my $password = shift;
    my $email    = shift;
    my $format   = shift;
    
    return status_bad_request('E-mail address '.$email.' not valid (RFC822).') unless (valid($email));
    
    my $csh = Crypt::SaltedHash->new(algorithm => 'PBKDF2');
    $csh->add($password);
    my $salted = $csh->generate;
    
    my $user   = $self->{factory}->createUserForRegistration($username, $salted, $email);
    my $userId = $self->{factory}->{gateway}->registerUser($user);
    
    if ($userId eq $self->{factory}->{gateway}->ERROR_USERNAME_EXISTS) {
        return status_bad_request("Username $username already exists in database.");
    }
    
    if ($userId eq $self->{factory}->{gateway}->ERROR_EMAIL_EXISTS) {
        return status_bad_request("Email address $email already exists in database.");
    }
    
    if ($userId ne 0) {
        return status_created({id => $userId});
    } else {
        return status_bad_request("User could not be created.");
    }
}

1;
