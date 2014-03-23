package Openponies::Entity::Abstract::Gateway;

use warnings;
use strict;

sub new {
    my $class    = shift;
    my $dbHandle = shift;

    my $self = {
        dbHandle => $dbHandle
    };

    bless  $self, $class;
    return $self;
}

1;
