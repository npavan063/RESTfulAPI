package Openponies::Routing::Users;

use Dancer ':syntax';
use Dancer::Plugin::Database;

use Openponies;
use Openponies::Entity::User::Gateway;
use Openponies::Entity::User::Factory;
use Openponies::Controller::User;

use Data::UUID::MT;

my $dbHandle      = database();
my $uuidGenerator = Data::UUID::MT->new();
my $gateway       = Openponies::Entity::User::Gateway->new($dbHandle, $uuidGenerator);
my $factory       = Openponies::Entity::User::Factory->new($gateway);
my $controller    = Openponies::Controller::User->new($factory);

hook 'before' => sub {
    if (defined params->{username} && defined params->{password}) {
        var user => $controller->authenticate(params->{username}, params->{password});

        if (vars->{user} == 0) {
            request->path_info('/user/unauthorized');
        }
    }
};

prefix '/user';

get '/unauthorized' => sub {
    status 'unauthorized';
    return({'error' => 'Authentication rejected - Incorrect username or password.'});
};

get '/forbidden' => sub {
    status 'forbidden';
    return({'error' => 'Access denied - You do not have access to that resource.'});
};

1;
