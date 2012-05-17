package resources::experiment;

use CGI;
use JSON;

use LWP::UserAgent;

my $cgi = new CGI;
my $json = new JSON;
$json = $json->utf8();

sub about {
  my $content = { 'description' => "An experiment is a combination of conditions for which gene expression
information is desired. The result of the experiment is a set of expression
levels for features under the given conditions.
It has the following fields:

=over 4


=item source

Publication or lab relevant to this experiment.



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
    my $data = { 'params' => [ 0, 1000000, [ "id", "source" ] ],
		  'method' => 'CDMI_EntityAPI.all_entities_Experiment',
		  'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};
    
    my $experiment_list = [];
    foreach my $key (keys(%{$response->[0]})) {
      push(@$experiment_list, $response->[0]->{$key});
    }
    
    print $cgi->header(-type => 'application/json',
			-status => 200,
			-Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $experiment_list );
    exit 0;
  }

  if (! $rest || ! scalar(@$rest)) {    
    my $data = { 'params' => [ 0, 1000000, ["id"] ],
		 'method' => 'CDMI_EntityAPI.all_entities_Experiment',
		 'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};

    my $experiment_list = [];
    @$experiment_list = map { keys(%$_) } @$response;

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $experiment_list );
    exit 0;
  }

  if ($rest && scalar(@$rest) == 1) {
    my $data = { 'params' => [ [ $rest->[0] ], [ "id", "source" ] ],
		 'method' => 'CDMI_EntityAPI.get_entity_Experiment',
		 'version' => "1.1" };
    
    my $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    my $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    my @k = keys(%{$response->{result}->[0]});
    my $experiment = $response->{result}->[0]->{$k[0]};
    $experiment->{url} = $cgi->url."/experiment/".$rest->[0];

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_HasResultsFor',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $probeset_ids = [];
    @$probeset_ids = map { $_->[2]->{id} } @$response;
    $experiment->{probesets} = $probeset_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_OperatesIn',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $media_ids = [];
    @$media_ids = map { $_->[2]->{id} } @$response;
    $experiment->{medias} = $media_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_HasValueFor',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $attribute_ids = [];
    @$attribute_ids = map { $_->[2]->{id} } @$response;
    $experiment->{attributes} = $attribute_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_AffectsLevelOf',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $atomicregulon_ids = [];
    @$atomicregulon_ids = map { $_->[2]->{id} } @$response;
    $experiment->{atomicregulons} = $atomicregulon_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_IndicatesSignalFor',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $feature_ids = [];
    @$feature_ids = map { $_->[2]->{id} } @$response;
    $experiment->{features} = $feature_ids;
    my $out = $json->encode( $experiment );
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