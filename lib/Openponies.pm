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
    if (vars->{user} == 0) {
        request->path_info('/user/unauthorized');
    }
}

1;
