package Openponies::Controller::Pony;

sub new {
    my $class = shift;

    my $self = {};

    bless  $self, $class;
    return $self;
}

sub viewPonyById {
    my $class = shift;
    my $id    = shift;

    return {success => $id};
}

sub viewPonyByName {
    my $class = shift;
    my $name  = shift;

    return {success => $name};
}

1;
