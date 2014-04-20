package Openponies::Controller::User;

use warnings;
use strict;

use Openponies;
use Openponies::Service::Random;
use Openponies::Service::Mail::User;

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
    my $email    = shift;
    my $format   = shift;
    
    my $generator = Openponies::Service::Random->new();
    my $password  = $generator->generatePassword();
    
    unless (defined $username && defined $password && defined $email &&
            $username ne ''   && $password ne ''   && $email ne '') {
                return status_bad_request('Must send username, password & email parameters.');
    }
    
    # Validate email address, username
    return status_bad_request("E-mail address $email not valid (RFC822).")               unless (valid($email));
    return status_bad_request('Username must be under 60 characters and alphanumeric.')  unless ($username =~ /^[A-Za-z0-9]{1,60}$/);
    
    my $salted = passphrase($password)->generate();
    
    my $user   = $self->{factory}->createUserForRegistration($username, $salted, $email);
    my $userId = $self->{factory}->{gateway}->registerUser($user);
    
    # Return an error if the user or email exists, or user failed to create
    return status_bad_request("Username $username already exists in database.")
        if ($userId eq $self->{factory}->{gateway}->ERROR_USERNAME_EXISTS);
    return status_bad_request("Email address $email already exists in database.")
        if ($userId eq $self->{factory}->{gateway}->ERROR_EMAIL_EXISTS);
    return status_bad_request("User could not be created.")
        if ($userId eq 0);
    
    my $mailer = Openponies::Service::Mail::User->new();
    my $result = $mailer->sendPasswordByEmail($email, $username, $password);
    
    if ($result eq $mailer->CANT_SEND_MAIL) {
        $self->{factory}->{gateway}->deleteUserByUsername($username);
        status 'internal_server_error';
        return ({error => "Failed to send password e-mail"});
    }
    
    return status_created({id => $userId});
}

sub changePassword {
    my $self        = shift;
    my $newPassword = shift;

    return status_bad_request('Must send new password.')
        unless (defined $newPassword && $newPassword ne '');
    return status_bad_request('Password must be 8-72 characters and contain a lowercase, uppercase & special character')
        unless ($newPassword =~ /^\S*(?=\S*[a-z])(?=\S*[A-Z])(?=\S*[\d])(?=\S{8,72})\S*$/);

    my $salted = passphrase($newPassword)->generate();
        
    my $username = vars->{user}->getUsername();
    my $result   = $self->{factory}->{gateway}->updatePassword($username, $salted);
    
    if ($result ne 0) {
        return status_accepted({id => vars->{user}->getId()});
    } else {
        return status_bad_request("Password could not be updated.");
    }
}

1;
