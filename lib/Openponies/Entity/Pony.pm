package Openponies::Entity::Pony;

use warnings;
use strict;

use DateTime;
use DateTime::Format::MySQL;

use Data::Dumper;

my %data = (
    id             => '1',
    appearance     => '1',
    description    => '1',
    gender         => '1',
    name           => '1',
    place_birth_id => '1',
    place_home_id  => '1',
    species_id     => '1',
    dt_created     => '1'
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
