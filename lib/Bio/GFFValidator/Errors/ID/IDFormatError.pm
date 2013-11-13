package Bio::GFFValidator::Errors::ID::IDFormatError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks the ID (column 1) of the feature does not contain an unescaped > at the start
NOTE: This error is caught by the Bio Perl parser and so we do not make use of this object

=method 


=cut

use Moose;

extends "Bio::GFFValidator::Errors::BaseError";

has 'id'        => ( is => 'ro', isa => 'Str',  required => 1 );

sub validate {

	my ($self) = @_;
	if($self->id){
		if($self->id =~ /^\>/){
			$self->set_error_message("line_number", "", "ID contains an unescaped > symbol at the start");
		}
		
	}
	
	return $self;
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
