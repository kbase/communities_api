package resources::scenario;

use CGI;
use JSON;

use LWP::UserAgent;

my $cgi = new CGI;
my $json = new JSON;
$json = $json->utf8();

sub about {
  my $content = { 'description' => "A scenario is a partial instance of a subsystem with a
defined set of reactions. Each scenario converts input compounds to
output compounds using reactions. The scenario may use all of the
reactions controlled by a subsystem or only some, and may also
incorporate additional reactions. Because scenario names are not
unique, the actual scenario ID is a number.
It has the following fields:

=over 4


=item common_name

Common name of the scenario. The name, rather than the ID
number, is usually displayed everywhere.



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
    my $data = { 'params' => [ 0, 1000000, [ "id", "common_name" ] ],
		  'method' => 'CDMI_EntityAPI.all_entities_Scenario',
		  'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};
    
    my $scenario_list = [];
    foreach my $key (keys(%{$response->[0]})) {
      push(@$scenario_list, $response->[0]->{$key});
    }
    
    print $cgi->header(-type => 'application/json',
			-status => 200,
			-Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $scenario_list );
    exit 0;
  }

  if (! $rest || ! scalar(@$rest)) {    
    my $data = { 'params' => [ 0, 1000000, ["id"] ],
		 'method' => 'CDMI_EntityAPI.all_entities_Scenario',
		 'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};

    my $scenario_list = [];
    @$scenario_list = map { keys(%$_) } @$response;

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $scenario_list );
    exit 0;
  }

  if ($rest && scalar(@$rest) == 1) {
    my $data = { 'params' => [ [ $rest->[0] ], [ "id", "common_name" ] ],
		 'method' => 'CDMI_EntityAPI.get_entity_Scenario',
		 'version' => "1.1" };
    
    my $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    my $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    my @k = keys(%{$response->{result}->[0]});
    my $scenario = $response->{result}->[0]->{$k[0]};
    $scenario->{url} = $cgi->url."/scenario/".$rest->[0];

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_HasParticipant',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $reaction_ids = [];
    @$reaction_ids = map { $_->[2]->{id} } @$response;
    $scenario->{reactions} = $reaction_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_Overlaps',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $diagram_ids = [];
    @$diagram_ids = map { $_->[2]->{id} } @$response;
    $scenario->{diagrams} = $diagram_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_Validates',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $subsystem_ids = [];
    @$subsystem_ids = map { $_->[2]->{id} } @$response;
    $scenario->{subsystems} = $subsystem_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_HasAsTerminus',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $compound_ids = [];
    @$compound_ids = map { $_->[2]->{id} } @$response;
    $scenario->{compounds} = $compound_ids;
    my $out = $json->encode( $scenario );
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