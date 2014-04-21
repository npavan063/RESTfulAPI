package Openponies::Routing::Species;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Species::Gateway;
use Openponies::Entity::Species::Factory;
use Openponies::Controller::Species;
use Openponies::Service::Authorization;

use Data::UUID::MT;

my $dbh                      = database();
$dbh->{mysql_auto_reconnect} = 1;

my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Species::Gateway->new($dbh, $uuidGenerator);
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
