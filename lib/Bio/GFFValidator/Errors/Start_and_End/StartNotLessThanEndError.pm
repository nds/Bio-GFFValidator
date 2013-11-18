package Bio::GFFValidator::Errors::Start_and_End::StartNotLessThanEndError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the start of the feature is less than the end. There is a special case when features are circular where this is not the case. 
=method 


=cut

use Moose;

use Bio::SeqFeatureI;
#use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object

sub validate {

	my ($self) = @_;
	
 	my $start = $self->feature->start;
 	my $end = $self->feature->end;

	
	if($self->feature->has_tag('is_circular')){
		# Do special checks for circular features (to be implemented)
	
	}else{
	
		# Is the start of the feature less than the end?
		if($start > $end){
			$self->set_error_message("line_number", "", "Start of feature ($start) should be less than the end ($end)" );	
		}
	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;