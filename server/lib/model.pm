package resources::model;

use CGI;
use JSON;

use LWP::UserAgent;

my $cgi = new CGI;
my $json = new JSON;
$json = $json->utf8();

sub about {
  my $content = { 'description' => "A model specifies a relationship between sets of features and
reactions in a cell. It is used to simulate cell growth and gene
knockouts to validate annotations.
It has the following fields:

=over 4


=item mod_date

date and time of the last change to the model data


=item name

descriptive name of the model


=item version

revision number of the model


=item type

ask Chris


=item status

indicator of whether the model is stable, under
construction, or under reconstruction


=item reaction_count

number of reactions in the model


=item compound_count

number of compounds in the model


=item annotation_count

number of annotations used to build the model



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
    my $data = { 'params' => [ 0, 1000000, [ "id", "mod_date", "name", "version", "type", "status", "reaction_count", "compound_count", "annotation_count" ] ],
		  'method' => 'CDMI_EntityAPI.all_entities_Model',
		  'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};
    
    my $model_list = [];
    foreach my $key (keys(%{$response->[0]})) {
      push(@$model_list, $response->[0]->{$key});
    }
    
    print $cgi->header(-type => 'application/json',
			-status => 200,
			-Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $model_list );
    exit 0;
  }

  if (! $rest || ! scalar(@$rest)) {    
    my $data = { 'params' => [ 0, 1000000, ["id"] ],
		 'method' => 'CDMI_EntityAPI.all_entities_Model',
		 'version' => "1.1" };
    
    my $response = $json->decode($ua->post($cdmi_url, Content => $json->encode($data))->content);
    $response = $response->{result};

    my $model_list = [];
    @$model_list = map { keys(%$_) } @$response;

    print $cgi->header(-type => 'application/json',
		       -status => 200,
		       -Access_Control_Allow_Origin => '*' );
    
    print $json->encode( $model_list );
    exit 0;
  }

  if ($rest && scalar(@$rest) == 1) {
    my $data = { 'params' => [ [ $rest->[0] ], [ "id", "mod_date", "name", "version", "type", "status", "reaction_count", "compound_count", "annotation_count" ] ],
		 'method' => 'CDMI_EntityAPI.get_entity_Model',
		 'version' => "1.1" };
    
    my $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    my $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    my @k = keys(%{$response->{result}->[0]});
    my $model = $response->{result}->[0]->{$k[0]};
    $model->{url} = $cgi->url."/model/".$rest->[0];

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_IsARequirementIn',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $requirement_ids = [];
    @$requirement_ids = map { $_->[2]->{id} } @$response;
    $model->{requirements} = $requirement_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_Models',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $genome_ids = [];
    @$genome_ids = map { $_->[2]->{id} } @$response;
    $model->{genomes} = $genome_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_IsDividedInto',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $modelcompartment_ids = [];
    @$modelcompartment_ids = map { $_->[2]->{id} } @$response;
    $model->{modelcompartments} = $modelcompartment_ids;

	$data = { 'params' => [ [ $rest->[0] ], [ "id" ], [], [ "id" ] ],
	      'method' => 'CDMI_EntityAPI.get_relationship_Manages',
	      'version' => "1.1" };
    $content = $json->encode($data);
    $content =~ s/%7C/|/g;
    $response = $json->decode($ua->post($cdmi_url, Content => $content)->content);
    $response = $response->{result}->[0];
    my $biomass_ids = [];
    @$biomass_ids = map { $_->[2]->{id} } @$response;
    $model->{biomasss} = $biomass_ids;
    my $out = $json->encode( $model );
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