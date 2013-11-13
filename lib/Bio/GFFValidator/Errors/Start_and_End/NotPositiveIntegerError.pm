package Bio::GFFValidator::Errors::Start_and_End::NotPositiveIntegerError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the start and end of a feature are positive integers
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
	
	# Are the start and end values positive integers?
	if($start < 0 or $end < 0 or $start =~ /\D/ or $end =~ /\D/){
		$self->set_error_message("line_number", "", "Start and end values should be positive integers" );	
	}
	
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
