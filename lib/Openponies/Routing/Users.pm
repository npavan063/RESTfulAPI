package Openponies::Routing::Users;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies;
use Openponies::Entity::User::Gateway;
use Openponies::Entity::User::Factory;
use Openponies::Controller::User;

use Data::UUID::MT;

my $dbh                      = database();
$dbh->{mysql_auto_reconnect} = 1;

my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::User::Gateway->new($dbh, $uuidGenerator);
my $factory       = Openponies::Entity::User::Factory->new($gateway);
my $controller    = Openponies::Controller::User->new($factory);

hook 'before' => sub {
    if (defined params->{username} && defined params->{password}) {
        var user => $controller->authenticate(params->{username}, params->{password});
    }
};

prefix '/user';

get '/checklogin.:format' => sub {
    return $controller->successfulLogin() if (Openponies->checkLoggedIn() eq 1);
};

any '/unauthorized' => sub {
    status 'unauthorized';
    return({error => 'Authentication rejected - Incorrect username or password.'});
};

any '/forbidden' => sub {
    status 'forbidden';
    return({error => 'Access denied - You do not have access to that resource.'});
};

post '/register.:format' => sub {
    my $username = param('username');
    my $email    = param('email');
    my $format   = param('format');
    
    return $controller->register($username, $email, $format);
};

options '/register.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

put '/changepassword.:format' => sub {
    if (Openponies->checkLoggedIn() eq 1) {
        my $newPassword = param('new_password');
        
        return $controller->changePassword($newPassword);
    }
};

options '/changepassword.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

put '/resetpassword.:format' => sub {
    my $username = param('username');
    my $email    = param('email');
    
    return $controller->requestReset($username, $email);
};

put '/confirmreset.:format' => sub {
    my $username = param('username');
    my $token    = param('token');
    
    return $controller->confirmReset($username, $token);
};

options '/resetpassword.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

options '/confirmreset.:format' => sub {
    header('Access-Control-Allow-Headers' => 'content-type');
    
    status 'ok';
    return {OK => 'OK'};
};

1;
