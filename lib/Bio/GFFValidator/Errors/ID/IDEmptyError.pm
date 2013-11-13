package Bio::GFFValidator::Errors::ID::IDEmptyError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the ID column in the feature is not empty
=method 


=cut

use Moose;

use Bio::SeqFeatureI;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object

sub validate {

	my ($self) = @_;
	
 	my $id = $self->feature->seq_id;
 		
 	# The field is unlikely to be empty because if it was the Bio Perl Parser would have complained by now.
 	# It can, however, have a . which is equivalent to an empty value
 	
	if(not defined $id or $id eq '.'){
		$self->set_error_message("line_number", "" , "ID column cannot be empty" );	
	}
		
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;