package Openponies::Service::Mail::User;

use Openponies::Service::Mail;
our @ISA = qw(Openponies::Service::Mail);

sub sendPasswordByEmail {
    my $self     = shift;
    my $to       = shift;
    my $username = shift;
    my $password = shift;
    
    my $subject = "Your Openponies Password";
    
    (my $body = << "    END_MESSAGE") =~ s/^ {4}//gm;
    Dear $username,
    
    Thanks for registering with Openponies.
    
    A password has been randomly generated for you: $password
    
    Please login with this password and change it.
    
    NOTE: Please do not reply to this e-mail.
    
    Regards,
    Openponies Support.
    END_MESSAGE

    return $self->sendEmail($to, $subject, $body);
}

1;