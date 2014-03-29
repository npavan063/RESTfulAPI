package Openponies::Entity::Pony;

use warnings;
use strict;

use DateTime;
use DateTime::Format::MySQL;

use Data::Dumper;

my %data = (
    id             => '',
    appearance     => '',
    description    => '',
    gender         => '',
    name           => '',
    place_birth_id => '',
    place_home_id  => '',
    species_id     => '',
    dt_created     => ''
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

sub getAppearance {
    my $self = shift;

    return $self->{appearance};
}

sub getDescription {
    my $self = shift;

    return $self->{description};
}

sub getGender {
    my $self = shift;

    return $self->{gender};
}

sub getName {
    my $self = shift;

    return $self->{name};
}

sub getDtCreated {
    my $self = shift;

    return $self->{dt_created};
}

sub getDtCreatedTimestamp {
    my $self = shift;

    my $dt = DateTime::Format::MySQL->parse_datetime($self->{dt_created});
    return $dt->epoch();
}

1;
