package Openponies::Entity::Abstract::Gateway;

use warnings;
use strict;

use Dancer;
use Dancer::Plugin::Memcached;

sub new {
    my $class         = shift;
    my $dbHandle      = shift;
    my $uuidGenerator = shift;

    my $self = {
        dbHandle      => $dbHandle,
        uuidGenerator => $uuidGenerator
    };

    bless  $self, $class;
    return $self;
}

sub generateUUID {
    my $self = shift;

    return $self->{uuidGenerator}->create_string();
}

sub store_cache {
    my $self    = shift;
    my $key     = shift;
    my $content = shift;

    memcached_store($key, $content);
}

sub get_cache {
    my $self = shift;
    my $key  = shift;

    return memcached_get($key);
}

1;
