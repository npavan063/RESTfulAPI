package Openponies::Controller::User;

use warnings;
use strict;

use Openponies;

use Dancer;
use Dancer::Plugin::REST;
use Dancer::Plugin::Passphrase;

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

    unless ($result eq 0) {
        if (passphrase($password)->matches($result->getPasswordHash())) {
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
    
    unless (defined $username && defined $password && defined $email &&
            $username ne ''   && $password ne ''   && $email ne '') {
        return status_bad_request('Must send username, password & email parameters.');
    }
    
    return status_bad_request("E-mail address $email not valid (RFC822).")               unless (valid($email));
    return status_bad_request('Username must be under 60 characters and alphanumeric.')  unless ($username =~ /^[A-Za-z0-9]{1,60}$/);
    return status_bad_request('Password must be 8-100 characters and contain a number.') unless ($password =~ /^\S*(?=\S*[\d])(?=\S{8,100})\S*$/);
    
    my $salted = passphrase($password)->generate();
    
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
