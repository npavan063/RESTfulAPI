package Openponies::Entity::User;

use warnings;
use strict;

use DateTime;
use DateTime::Format::MySQL;

use Data::Dumper;

my %data = (
    id            => '',
    login         => '',
    password      => '',
    email_address => '',
    roles         => '',
    name          => ''
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

sub getUsername {
    my $self = shift;

    return $self->{login};
}

sub getPasswordHash {
    my $self = shift;

    return $self->{password};
}

sub getEmailAddress {
    my $self = shift;

    return $self->{email_address};
}

sub getRoles {
    my $self = shift;

    return $self->{roles};
}

sub getName {
    my $self = shift;

    return $self->{name};
}

1;
