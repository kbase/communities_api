package resources::requirement;

use CGI;
use JSON;

use LWP::UserAgent;

my $cgi = new CGI;
my $json = new JSON;
$json = $json->utf8();

sub about {
  my $content = { 'description' => "A requirement describes the way a reaction fits
into a model.
It has the following fields:

=over 4


=item direction

reaction directionality (> for forward, < for
backward, = for bidirectional) with respect to this model


=item transproton

ask Chris


=item proton

ask Chris



=back


",
		  'parameters' => { "id" => "string" },
		  'return_type' => "application/json" };

  print $cgi->header(-type => 'application/json',
		     -status => 200,
		     -Access_Control_Allow_Origin => '*' );
  print $json->encode($content);
  exit 0;
}

sub request {
  my ($params) = @_;

  my $rest = $params->{rest_parameters};
  my $cgiparams = $params->{cgi_parameters};

  if (exists $cgiparams->{'about'}) {
    &about();
    exit 0;
  }

  my $ua = LWP::UserAgent->new;
  my $cdmi_url = "http://bio-data-1.mcs.anl.gov/services/cdmi_api";

  if (exists $cgiparams->{'verbose'}) {
    my $data = { 'params' => [ 0, 1000000, [ "id", "direction", "transproton", "proton" ] ],
		  'method' => 'CDMI_EntityAPI.all_entities_Requirement',
		  'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};
    
    my $requirement_list = [];
    foreach my $key (keys(%{$response->[0]})) {
      push(@$requirement_list, $response->[0]->{$key});
    }
    
    print $cgi->header(-type => 'application/json',
			-status => 200,
			-Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $requirement_list );
    exit 0;
  }

  if (! $rest || ! scalar(@$rest)) {    
    my $data = { 'params' => [ 0, 1000000, ["id"] ],
		 'method' => 'CDMI_EntityAPI.all_entities_Requirement',
		 'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};

    my $requirement_list = [];
    @$requirement_list = map { keys(%$_) } @$response;

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $requirement_list );
    exit 0;
  }

  if ($rest && scalar(@$rest) == 1) {
    my $data = { 'params' => [ [ $rest->[0] ], [ "id", "direction", "transproton", "proton" ] ],
		 'method' => 'CDMI_EntityAPI.get_entity_Requirement',
		 'version' => "1.1" };
    
    my $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    my $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    my @k = keys(%{$response->{result}->[0]});
    my $requirement = $response->{result}->[0]->{$k[0]};
    $requirement->{url} = $cgi->url."/requirement/".$rest->[0];

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_Requires',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $reaction_ids = [];
    @$reaction_ids = map { $_->[2]->{id} } @$response;
    $requirement->{reactions} = $reaction_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_HasRealLocationIn',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $modelcompartment_ids = [];
    @$modelcompartment_ids = map { $_->[2]->{id} } @$response;
    $requirement->{modelcompartments} = $modelcompartment_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_IsARequirementOf',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $model_ids = [];
    @$model_ids = map { $_->[2]->{id} } @$response;
    $requirement->{models} = $model_ids;
    my $out = $json->encode( $requirement );
    $out =~ s/%7C/|/g;

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    
    print $out;
    exit 0;
  }
}

sub TO_JSON { return { %{ shift() } }; }

1;