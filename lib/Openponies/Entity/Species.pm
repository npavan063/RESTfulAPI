package Openponies::Entity::Species;

use warnings;
use strict;

use Data::Dumper;

my %data = (
    id             => '1',
    description    => '1',
    name           => '1'
);

sub new {
    my $class = shift;
    my $data  = shift;

    my $self = {};
    my %vars = %{$data};

    foreach my $key (keys %vars) {
        # We only want to assign keys that exist
        if (exists($data{$key})) {
            $self->{$key} = $vars{$key};
        } else {
            next;
        }
    }

    bless  $self, $class;
    return $self;
}

sub getId {
    my $self = shift;

    return $self->{id};
}

sub getDescription {
    my $self = shift;

    return $self->{description};
}

sub getName {
    my $self = shift;

    return $self->{name};
}

1;
