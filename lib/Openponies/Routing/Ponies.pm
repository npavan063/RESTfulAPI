package Openponies::Routing::Ponies;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Pony::Gateway;
use Openponies::Entity::Pony::Factory;
use Openponies::Controller::Pony;

use Data::UUID::MT;

my $dbHandle      = database();
my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Pony::Gateway->new($dbHandle, $uuidGenerator);
my $factory       = Openponies::Entity::Pony::Factory->new($gateway);
my $controller    = Openponies::Controller::Pony->new($factory);

prefix '/pony';

get '/byid/:id.:format' => sub {
    my $id     = params->{id};
    my $format = params->{format};
    return $controller->viewPonyById($id, $format);
};

get '/byname/:name.:format' => sub {
    my $name   = params->{name};
    my $format = params->{format};
    return $controller->viewPonyByName($name, $format);
};

1;
