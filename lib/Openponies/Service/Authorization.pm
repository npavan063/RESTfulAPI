package Openponies::Service::Authorization;

use warnings;
use strict;

use Dancer;
use Openponies;

use constant DOESNT_HAVE_ROLE => -1;
use constant NOT_LOGGED_IN    => -2;
use constant IS_BANNED        => -3;

sub checkLoggedIn {
    return Openponies::Service::Authorization->NOT_LOGGED_IN
        if (vars->{user} eq 0 || !defined vars->{user});
    return Openponies::Service::Authorization->IS_BANNED
        if (vars->{user}->getBanned() eq 1);
    
    return 1;
}

sub checkHasRole {
    my $class = shift;
    my $role  = shift;
    my @roles = @{vars->{user}->getRolesArray()};
    
    return 1 if ($role ~~ @roles);
    return Openponies::Service::Authorization->DOESNT_HAVE_ROLE;
}

sub loggedInOrRedirect {
    my $result = Openponies::Service::Authorization->checkLoggedIn();
    
    return forward('/user/unauthorized')
        if ($result eq Openponies::Service::Authorization->NOT_LOGGED_IN);
    return forward('/user/yourebanned')
        if ($result eq Openponies::Service::Authorization->IS_BANNED);
    return 1;
}

1;