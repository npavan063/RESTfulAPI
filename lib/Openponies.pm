package Openponies;

use Dancer ':syntax';
use Dancer::Plugin::REST;

use Module::Load;

our $VERSION = '0.1';

prepare_serializer_for_format;

load Openponies::Routing::Places;
load Openponies::Routing::Ponies;
load Openponies::Routing::Species;
load Openponies::Routing::Users;

1;
