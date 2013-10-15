package Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that all CDS features have a strand
=method 


=cut

use Moose;

use Bio::SeqFeature::Generic;

#use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeature::Generic', required => 1 ); #The feature object

sub validate {

	my ($self) = @_;
	
 	my $phase = $self->feature->frame;
 	my $type = $self->feature->primary_tag;
 	
 	if(uc($type) eq "CDS" and $phase !~ /[012]/) {
 		$self->set_error_message("line_number", $self->feature->seq_id, "Phase cannot be unspecified for CDS features. Should be 0,1 or 2." );	
	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;