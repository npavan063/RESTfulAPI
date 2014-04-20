package Openponies::Service::Random;

use warnings;
use strict;

use String::Urandom;

sub new {
    my $class = shift;
    my $self  = {};

    bless  $self, $class;
    return $self;
}

sub generatePassword {
    my $self = shift;
    
    my $generator = String::Urandom->new(LENGTH => 16);
    my $password  = $generator->rand_string();
    
    return $password;
}

1;