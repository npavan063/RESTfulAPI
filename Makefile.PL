use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Openponies',
    AUTHOR              => q{SUHOSIN PONY <devel@manehattan.com>},
    VERSION_FROM        => 'lib/Openponies.pm',
    ABSTRACT            => 'Openponies RESTful API',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'YAML'                     => 0,
        'XML::Simple'              => 0,
        'JSON'                     => 0,
        'Dancer'                   => 1.3121,
        'Dancer::Plugin::REST'     => 0,
        'Dancer::Plugin::Database' => 0,
        'Data::UUID::MT'           => 0,
        'DateTime::Format::MySQL'  => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Openponies-*' },
);
