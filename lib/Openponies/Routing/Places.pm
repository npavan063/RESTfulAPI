package Openponies::Routing::Places;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Place::Gateway;
use Openponies::Entity::Place::Factory;
use Openponies::Controller::Place;
use Openponies::Service::Authorization;

use Data::UUID::MT;

my $dbh                      = database();
$dbh->{mysql_auto_reconnect} = 1;

my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::Place::Gateway->new($dbh, $uuidGenerator);
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

post '/add.:format' => sub {
    if (Openponies::Service::Authorization->loggedInOrRedirect() eq 1) {
        my $name         = param('name');
        my $description  = param('description');
        
        return $controller->createPlace($name, $description);
    }
};

options '/add.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

1;
