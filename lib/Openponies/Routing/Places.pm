package Openponies::Routing::Places;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Place::Gateway;
use Openponies::Entity::Place::Factory;
use Openponies::Controller::Place;

use Data::UUID::MT;

my $dbHandle      = database();
my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Place::Gateway->new($dbHandle, $uuidGenerator);
my $factory       = Openponies::Entity::Place::Factory->new($gateway);
my $controller    = Openponies::Controller::Place->new($factory);

prefix '/place';

get '/:id.:format' => sub {
    my $id = params->{id};
    return $controller->viewPlaceById($id);
};

1;
