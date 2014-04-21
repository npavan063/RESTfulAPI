package Openponies::Entity::User;

use warnings;
use strict;

use DateTime;
use DateTime::Format::MySQL;

my %data = (
    id                 => '',
    login              => '',
    password           => '',
    email_address      => '',
    roles              => '',
    name               => '',
    reset_token        => '',
    reset_token_expiry => '',
    last_login         => '',
    banned             => '',
    ban_reason         => '',
    banned_by          => ''
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

sub getRolesArray {
    my $self  = shift;
    my @roles = split(/,\s*/, $self->{roles});
    
    return \@roles;
}

sub getName {
    my $self = shift;

    return $self->{name};
}

sub getResetToken {
    my $self = shift;
    
    return $self->{reset_token};
}

sub getResetTokenExpiry {
    my $self = shift;
    
    return $self->{reset_token_expiry};
}

sub getLastLogin {
    my $self = shift;
    
    return $self->{last_login};
}

sub getResetTokenExpiryTimestamp {
    my $self = shift;

    my $dt = DateTime::Format::MySQL->parse_datetime($self->{reset_token_expiry});
    return $dt->epoch();
}

sub getBanned {
    my $self = shift;
    
    return $self->{banned}
        if (defined $self->{banned} && $self->{banned} ne '');
    return 0;
}

1;
