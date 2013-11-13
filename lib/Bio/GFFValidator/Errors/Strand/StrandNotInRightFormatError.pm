package Bio::GFFValidator::Errors::Strand::StrandNotInRightFormatError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks that the strand of the feature is +, -, . or ?
=method 


=cut

use Moose;

use Bio::SeqFeatureI;
#use Data::Dumper;

extends "Bio::GFFValidator::Errors::BaseError";

has 'feature'   	=> ( is => 'ro', isa => 'Bio::SeqFeatureI', required => 1 ); #The feature object

sub validate {

	my ($self) = @_;
	
 	my $strand = $self->feature->strand;
 	
	# The valid characters for the strand are [+-.?]. When Bio Perl parses them, the strand becomes 1,-1,0 or undefined.
	# The question mark gets translated to undefined which is the same as when the parser encounters any erroneous characters in the strand column. So, impossible to distinguish easily.
	# For now, we limit the possible options to +, - or .
 		
	if(not defined $strand or (defined $strand and $strand !~ /^1|0|-1$/)){
		$self->set_error_message("line_number", "", "Strand ($strand) is invalid. Should be +, - or ." );	
	}
		
	return $self;
	
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;