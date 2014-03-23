package Openponies::Entity::Pony;

use DateTime;
use DateTime::Format::MySQL;

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

    croak "Illegal parameter list has odd number of values" if @_ % 2;

    my %vars  = @_;

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
    return $self->{id};
}

sub getAppearance {
    return $self->{appearance};
}

sub getDescription {
    return $self->{description};
}

sub getGender {
    return $self->{gender};
}

sub getName {
    return $self->{name};
}

sub getDtCreated {
    return $self->{dt_created};
}

sub getDtCreatedTimestamp {
    my $dt = DateTime::Format::MySQL->format_datetime($self->{dt_created});
    return $dt->epoch();
}

1;
