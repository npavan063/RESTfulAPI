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
    
    NOTE: Please do not reply to this e-mail. We do not monitor this account.
    
    Regards,
    Openponies Support.
    END_MESSAGE

    return $self->sendEmail($to, $subject, $body);
}

sub sendRandomPasswordByEmail {
    my $self     = shift;
    my $to       = shift;
    my $username = shift;
    my $password = shift;
    
    my $subject = "Openponies Password Reset Successful";
    
    (my $body = << "    END_MESSAGE") =~ s/^ {4}//gm;
    Dear $username,
    
    This is your newly requested password: $password
    
    If you did not request this, someone else has access to your e-mail account.
    
    NOTE: Please do not reply to this e-mail. We do not monitor this account.
    
    Regards,
    Openponies Support.
    END_MESSAGE

    return $self->sendEmail($to, $subject, $body);
}

sub sendResetUrlByEmail {
    my $self     = shift;
    my $to       = shift;
    my $username = shift;
    my $resetUrl = shift;
    
    my $subject = "Openponies Password Reset Request";
    
    (my $body = << "    END_MESSAGE") =~ s/^ {4}//gm;
    Dear $username,
    
    We have received a password reset request for your account.
    
    Please visit $resetUrl to confirm your request. Note: You must use this reset token within 24 hours of the original reset request.
    
    If you did not make this request, please ignore this e-mail.
    
    NOTE: Please do not reply to this e-mail. We do not monitor this account.
    
    Regards,
    Openponies Support.
    END_MESSAGE

    return $self->sendEmail($to, $subject, $body);
}

sub sendBanByEmail {
    my $self     = shift;
    my $to       = shift;
    my $username = shift;
    my $admin    = shift;
    my $reason   = shift;
    
    my $subject = "Openponies Password Reset Request";
    
    (my $body = << "    END_MESSAGE") =~ s/^ {4}//gm;
    Dear $username,
    
    Your account has been banned for breaching Openponies rules.
    
    The reason given was: $reason
    
    Please contact Openponies support if you believe this email was sent in error.
    
    NOTE: Please do not reply to this e-mail. We do not monitor this account.
    
    Regards,
    Openponies Support.
    END_MESSAGE

    return $self->sendEmail($to, $subject, $body);
}

1;