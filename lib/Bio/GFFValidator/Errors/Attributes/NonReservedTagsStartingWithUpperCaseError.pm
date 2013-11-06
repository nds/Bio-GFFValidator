package Bio::GFFValidator::Errors::Attributes::NonReservedTagsStartingWithUpperCaseError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that only reserved tags start with a capital letter

=method 


=cut

use Moose;
use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'tag'   		=> ( is => 'ro', isa => 'Str', required => 1 ); #Tag
has 'feature_id'	=> ( is => 'ro', isa => 'Str', required => 1 ); #ID of feature

sub validate {

	my ($self) = @_;
	
 	if ( (lc($self->tag) !~ m/id|name|alias|parent|target|gap|derives_from|note|dbxref|ontology_term|is_circular/) and ($self->tag =~ /^[[:upper:]]/) ){
 		
 		$self->set_error_message("line_number", $self->feature_id, $self->tag." is not a reserved tag in GFF. It should not start with an uppercase character." );	
 			
 	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;