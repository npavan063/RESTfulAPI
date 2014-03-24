package Openponies::Entity::Abstract::Gateway;

use warnings;
use strict;

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

1;
