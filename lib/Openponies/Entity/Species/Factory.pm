package Openponies::Entity::Species::Factory;

use warnings;
use strict;

use Openponies::Entity::Abstract::Factory;
use Openponies::Entity::Species;

our @ISA = qw(Openponies::Entity::Abstract::Factory);

sub create {
    my $self = shift;
    my $vars = shift;

    return Openponies::Entity::Species->new($vars);
}

sub getSpeciesById {
    my $self = shift;
    my $id   = shift;

    my $data = $self->{gateway}->getSpeciesById($id);

    if ($data ne 0) {
        return $self->create($data);
    } else {
        return 0;
    }
}

sub getAllSpecies {
    my $self = shift;
    
    my $data = $self->{gateway}->getAllSpecies();
    
    if ($data ne 0) {
        my @species = ();
        
        foreach my $row (@{$data}) {
            push(@species, $self->create($row));
        }
        
        return \@species;
    } else {
        return 0;
    }
}

1;
