package Openponies::Service::Mail;

use Email::Sender::Simple qw(sendmail);
use Email::Simple::Creator;
use Email::Sender::Transport::SMTPS;
use Try::Tiny;
use Dancer;

use constant CANT_SEND_MAIL    => -1;
use constant SENT_SUCCESSFULLY => 1;

sub new {
    my $class   = shift;
    my $self    = {};

    bless  $self, $class;
    return $self;
}

sub sendEmail {
    my $self    = shift;
    my $to      = shift;
    my $subject = shift;
    my $body    = shift;
    my $failed  = 0;
    
    my $email = Email::Simple->create(
        header => [
            To      => $to,
            From    => 'noreply@openponies.com',
            Subject => $subject
        ],
        body => $body
    );
    
    my $transport = Email::Sender::Transport::SMTPS->new({
        host          => config->{smtp_host},
        port          => config->{smtp_port},
        sasl_username => config->{smtp_username},
        sasl_password => config->{smtp_password},
        ssl           => 'ssl'
    });
    
    try {
        sendmail($email, {transport => $transport});
    } catch {
        $failed = 1;
    };
    
    return $self->CANT_SEND_MAIL if ($failed eq 1);
    return $self->SENT_SUCCESSFULLY;
}

1;