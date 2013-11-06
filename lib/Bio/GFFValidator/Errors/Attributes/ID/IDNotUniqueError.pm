package Bio::GFFValidator::Errors::Attributes::ID::IDNotUniqueError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the IDs within the GFF file are unique. These are the values specified by the ID tag in the 9th column.

=method 


=cut

use Moose;

extends "Bio::GFFValidator::Errors::BaseError";

has 'ids'   	=> ( is => 'ro', isa => 'HashRef', required => 1 ); #A hash of ids with the number of times they are seen

sub validate {

	my ($self) = @_;
	
	my @non_unique_ids;
 	for my $id (keys $self->ids){
 		if($self->ids->{$id} > 1){
 			push(@non_unique_ids, $id); 		
 		}
 	
 	}
 	
 	if(@non_unique_ids){
 		$self->set_error_message("Whole file", "Non-unique IDs", "The following IDs are not unique: ".join(", ",@non_unique_ids) );	
 	}

	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;