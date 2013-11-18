package Bio::GFFValidator::Errors::Start_and_End::NotWithinRangeError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks the start and end of a feature to make sure it is within the range of the landmark feature.
If the feature is marked as being circular, this rule does not apply. There are different rules for
circular features - check specification and implement this.

=method 


=cut

use Moose;

use Bio::SeqFeatureI;
#use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object
has 'seq_regions'	=> ( is => 'ro', isa => 'HashRef', required => 1 ); # The hash of seq regions created by the parser

sub validate {

	my ($self) = @_;
	
 	my $coordinates = ${$self->seq_regions}{$self->feature->seq_id};
 	my $start = ${$coordinates}[0]; # Bit verbose, but probably be clearer in the long run
 	my $end = ${$coordinates}[1]; 
	
	# Is the start and end for this landmark feature specified to begin with?
	unless(defined $start and defined $end){
  		$self->set_error_message("line_number", "", "Start and end not specified in a sequence region line for ".$self->feature->seq_id );
  		return $self;
  	}
 	
 	# Start and end specified, so check the boundaries
	if($self->feature->has_tag('is_circular')){
		# Implement special checks for circular features
	}elsif($self->feature->start < $start ){
		$self->set_error_message("line_number", "", "Start of feature (".$self->feature->start.") is not within range"); 
	}elsif($self->feature->end > $end ){
		$self->set_error_message("line_number", "", "End of feature (".$self->feature->end.") is not within range"); 
	
	}
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
