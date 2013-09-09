use strict;
use warnings;

use Getopt::Long;

use LWP::UserAgent;
use JSON;

use Bio::KBase::IDServer::Client;

sub help {
  my $text = qq~
NAME
    mg-get-annotation-similarity.pl -- tab deliminted blast m8 with annotation for the specified metagenome

VERSION
    2

SYNOPSIS
    mg-get-annotation-similarity.pl [ --help, --user <user>, --pass <password>, --token <oAuth token>, --webkey <communities webkey>, --verbosity <verbosity level>--id <metagenome id>, --source, --length, --identity, --evalue, --filter, --type]

DESCRIPTION
    tab deliminted blast m8 with annotation for the specified metagenome

  Options
    help - display this message
    user - username to authenticate against the API, requires a password to be set as well
    pass - password to authenticate against the API, requires a username to be set as well
    token - Globus Online authentication token
    webkey - MG-RAST webkey to synch with the passed Globus Online authentication
    verbosity - verbosity of the result data, can be one of [ 'minimal', 'verbose', 'full' ]
    id - id of the metagenome
    source - annotation source, i.e. SEED, KEGG, ...
    length - minimum alignment length
    identity - minimum percent identity
    evalue - maximum evalue
    filter - return only results whose annotations contain this string
    type - organism, ontology, function or feature

  Output
    JSON structure that contains the result data

EXAMPLES
    -

SEE ALSO
    -

AUTHORS
    Jared Bischof, Travis Harrison, Folker Meyer, Tobias Paczian, Andreas Wilke

~;
  print $text;
}

my $HOST      = 'http://kbase.us/services/communities/1/annotation/';
my $user      = '';
my $pass      = '';
my $token     = '';
my $verbosity = 'full';
my $help      = '';
my $webkey    = '';
my $offset    = '0';
my $limit     = '10';
my $id        = undef;
 my $source = undef;
my $length = undef;
my $identity = undef;
my $evalue = undef;
my $filter = undef;
my $type = undef;
 

GetOptions ( 'user=s' => \$user,
             'pass=s' => \$pass,
             'token=s' => \$token,
             'verbosity=s' => \$verbosity,
             'help' => \$help,
             'webkey=s' => \$webkey,
             'limit=s' => \$limit,
             'offset' => \$offset,
	     'id=s' => \$id ,
	'source' => \$source,
	'length' => \$length,
	'identity' => \$identity,
	'evalue' => \$evalue,
	'filter' => \$filter,
	'type' => \$type);

if ($help) {
  &help();
  exit 0;
}

if ($user || $pass) {
  if ($user && $pass) {
    my $exec = 'curl -s -u '.$user.':'.$pass.' -X POST "https://nexus.api.globusonline.org/goauth/token?grant_type=client_credentials"';
    my $result = `$exec`;
    my $ustruct = "";
    eval {
      my $json = new JSON;
      $ustruct = $json->decode($result);
    };
    if ($@) {
      die "could not reach auth server";
    } else {
      if ($ustruct->{access_token}) {
        $token = $ustruct->{access_token};
      } else {
        die "authentication failed";
      }
    }
  } else {
    die "you must supply both username and password";
  }
}

if ($id && $id =~/^kb\|/) {
  my $id_server_url = "http://www.kbase.us/services/idserver";
  my $idserver = Bio::KBase::IDServer::Client->new($id_server_url);
  my $return = $idserver->kbase_ids_to_external_ids( [ $id ]);
  $id = $return->{$id}->[1];
}

if ($id) {
  $HOST .= "$id/";
}

my $subresource = "/similarity";
my $additionals = "";
if ($source) {
    $additionals .= "&source=$source";
}
if ($length) {
    $additionals .= "&length=$length";
}
if ($identity) {
    $additionals .= "&identity=$identity";
}
if ($evalue) {
    $additionals .= "&evalue=$evalue";
}
if ($filter) {
    $additionals .= "&filter=$filter";
}
if ($type) {
    $additionals .= "&type=$type";
} 

my $url = $HOST.$subresource."?verbosity=$verbosity&limit=$limit&offset=$offset".$additionals;
if ($webkey) {
  $url .= "&webkey=".$webkey;
}
my $ua = LWP::UserAgent->new;
if ($token) {
  $ua->default_header('user_auth' => $token);
}
print $ua->get($url)->content;
