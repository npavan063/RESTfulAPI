package Openponies::Routing::Places;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Place::Gateway;
use Openponies::Entity::Place::Factory;
use Openponies::Controller::Place;

use Data::UUID::MT;

my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Place::Gateway->new(database(), $uuidGenerator);
my $factory       = Openponies::Entity::Place::Factory->new($gateway);
my $controller    = Openponies::Controller::Place->new($factory);

prefix '/place';

get '/:id.:format' => sub {
    my $id     = params->{id};
    my $format = params->{format};

    return $controller->viewPlaceById($id, $format);
};

get '/all/all.:format' => sub {
    my $format = params->{format};
    
    return $controller->allPlaces();
};

1;
