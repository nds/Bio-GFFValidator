package Bio::GFFValidator::Errors::ID::IDFormatError;
# ABSTRACT: 

=head1 SYNOPSIS

Checks the ID (column 1) of the feature adheres to the right format

=method 


=cut

use Moose;

extends "Bio::GFFValidator::Errors::BaseError";

has 'id'        => ( is => 'ro', isa => 'Str',  required => 1 );

sub validate {

	my ($self) = @_;
	if($self->id){
		if($self->id =~ /^\>/){
			$self->line("line number");
			$self->value($self->id);
			$self->message("ID contains an unescaped > symbol at the start");
		}
		
	}
	
	return $self;
}

sub fix_it {




}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
