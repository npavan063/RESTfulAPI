package Openponies::Routing::Species;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Species::Gateway;
use Openponies::Entity::Species::Factory;
use Openponies::Controller::Species;

use Data::UUID::MT;

my $dbHandle      = database();
my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Species::Gateway->new($dbHandle, $uuidGenerator);
my $factory       = Openponies::Entity::Species::Factory->new($gateway);
my $controller    = Openponies::Controller::Species->new($factory);

prefix '/species';

get '/:id.:format' => sub {
    my $id = params->{id};
    return $controller->viewSpeciesById($id);
};

1;
