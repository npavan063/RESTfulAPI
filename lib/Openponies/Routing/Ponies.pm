package Openponies::Routing::Ponies;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies::Entity::Pony::Gateway;
use Openponies::Entity::Pony::Factory;
use Openponies::Controller::Pony;

use Openponies::Entity::Species::Gateway;
use Openponies::Entity::Species::Factory;
use Openponies::Controller::Species;

use Openponies::Entity::Place::Gateway;
use Openponies::Entity::Place::Factory;
use Openponies::Controller::Place;

use Data::UUID::MT;

my $dbh                      = database();
$dbh->{mysql_auto_reconnect} = 1;

my $uuidGenerator  = Data::UUID::MT->new();
my $gateway        = Openponies::Entity::Pony::Gateway->new($dbh, $uuidGenerator);
my $factory        = Openponies::Entity::Pony::Factory->new($gateway);
my $placeGateway   = Openponies::Entity::Place::Gateway->new($dbh, $uuidGenerator);
my $placeFactory   = Openponies::Entity::Place::Factory->new($placeGateway);
my $speciesGateway = Openponies::Entity::Species::Gateway->new($dbh, $uuidGenerator);
my $speciesFactory = Openponies::Entity::Species::Factory->new($speciesGateway);
my $controller     = Openponies::Controller::Pony->new($factory, $placeFactory, $speciesFactory);

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

get '/all/all.:format' => sub {
    my $format = params->{format};
    
    my $page  = 1;
    my $limit = 50;
    
    if (defined param('page') && param('page') =~ m/^\d+$/) {
        $page = param('page');
    }
        
    if (defined param('limit') && param('limit') =~ m/^\d+$/ && param('limit') <= 50) {
        $limit = param('limit');
    }
    
    return $controller->allPonies($format, $page, $limit);
};

get '/all/count.:format' => sub {
    my $format = params->{format};
    
    return $controller->countPonies();
};

post '/add.:format' => sub {
    if (Openponies->checkLoggedIn() eq 1) {
        my $name         = param('name');
        my $description  = param('description');
        my $appearance   = param('appearance');
        my $gender       = param('gender');
        my $placeBirthId = param('place_birth_id');
        my $placeHomeId  = param('place_home_id');
        my $speciesId    = param('species_id');
        
        return $controller->createPony($name, $description, $appearance, $gender, $placeBirthId, $placeHomeId, $speciesId);
    }
};

options '/add.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

1;
