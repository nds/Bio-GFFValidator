package Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that all CDS features have a strand and that it is 0, 1 or 2. 
If the phase is anything besides .,0,1 or 2 the Bio Perl parser will complain. So, here we really just need to 
check that for CDS features, the phase is 0, 1 or 2.

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
 		# If the strand is anything besides [.012] Bio Perl will throw an exception and this will get caught as a parser error
 		# Here we really want to avoid it being . when the type is CDS
 		$self->set_error_message("line_number", "", "Phase ($phase) incorrect for CDS features. Should be 0,1 or 2." );	
	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;