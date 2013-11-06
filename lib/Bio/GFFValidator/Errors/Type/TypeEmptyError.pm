package Bio::GFFValidator::Errors::Type::TypeEmptyError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the type column in the feature has a value
=method 


=cut

use Moose;

use Bio::SeqFeatureI;
#use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object

sub validate {

	my ($self) = @_;
	
 	my $type = $self->feature->primary_tag;
 		
 	# The field is unlikely to be empty because if it was the Bio Perl Parser would have complained by now.
 	# It can, however, have a . which is equivalent to an empty value
 	
	if(not defined $type or $type eq '.'){
		$self->set_error_message("line_number", $self->feature->seq_id, "Type cannot be empty" );	
	}
		
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;