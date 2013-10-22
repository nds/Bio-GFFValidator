package Bio::GFFValidator::Errors::Attributes::MultipleValuesError;
# ABSTRACT: 

=head1 SYNOPSIS

The GFF3 specification stipulates that some tags can only have 1 value. This module checks this is so.

=method 


=cut

use Moose;
use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'tag'   		    => ( is => 'ro', isa => 'Str', required => 1 ); #Tag
has 'tag_values'   		=> ( is => 'ro', isa => 'ArrayRef', required => 1 ); #Value(s)
has 'feature_id'	    => ( is => 'ro', isa => 'Str', required => 1 ); #ID of feature

sub validate {

	my ($self) = @_;
	
	my $count = scalar(@{$self->tag_values});
  	if ($count > 1 ){ 		
  		$self->set_error_message("line_number", $self->feature_id, $self->tag." has multiple values. Only one is allowed." );			
  	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;