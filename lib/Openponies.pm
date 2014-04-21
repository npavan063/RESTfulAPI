package Openponies;

use Dancer ':syntax';
use Dancer::Plugin::REST;

use Module::Load;

our $VERSION = '0.1';

prepare_serializer_for_format;

load Openponies::Routing::Places;
load Openponies::Routing::Ponies;
load Openponies::Routing::Species;
load Openponies::Routing::Users;

sub checkLoggedIn {
    if (vars->{user} eq 0 || !defined vars->{user}) {
        return forward('/user/unauthorized');
    } elsif (vars->{user}->getBanned() eq 1) {
        return forward('/user/yourebanned');
    }
    
    return 1;
}

sub checkHasRole {
    my $class = shift;
    my $role  = shift;
    my @roles = @{vars->{user}->getRolesArray()};
    
    return 1 if ($role ~~ @roles);
    return forward('/user/forbidden');
}

1;
