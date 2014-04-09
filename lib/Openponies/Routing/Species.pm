package Openponies::Routing::Species;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Species::Gateway;
use Openponies::Entity::Species::Factory;
use Openponies::Controller::Species;

use Data::UUID::MT;

my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Species::Gateway->new(database(), $uuidGenerator);
my $factory       = Openponies::Entity::Species::Factory->new($gateway);
my $controller    = Openponies::Controller::Species->new($factory);

prefix '/species';

get '/:id.:format' => sub {
    my $id     = params->{id};
    my $format = params->{format};

    return $controller->viewSpeciesById($id, $format);
};

get '/all/all.:format' => sub {
    my $format = params->{format};
    
    return $controller->allSpecies();
};

1;
