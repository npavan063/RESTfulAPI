package Openponies::Routing::Ponies;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Pony::Gateway;
use Openponies::Entity::Pony::Factory;
use Openponies::Controller::Pony;

my $dbhandle   = database();
#my $gateway    = Openponies::Entity::Pony::Gateway->new($dbhandle);
#my $factory    = Openponies::Entity::Pony::Factory->new($gateway);
#my $controller = Openponies::Controller::Pony->new($factory);
my $controller = Openponies::Controller::Pony->new();

prefix '/pony';

get '/byid/:id.:format' => sub {
    my $id = params->{id};
    return $controller->viewPonyById($id);
};

get '/byname/:name.:format' => sub {
    my $name = params->{name};
    return $controller->viewPonyById($name);
};

1;
