package Bio::GFFValidator::Errors::ID::IDFormatError;
# ABSTRACT: 

=head1 SYNOPSIS


=method 


=cut

use Moose;

extends "Bio::GFFValidator::Errors::BaseError";

has 'id'        => ( is => 'ro', isa => 'Str',  required => 1 );

sub validate
{
	my ($self) = @_;
	if($self->id){
		if($self->id =~ /^\>/){
			# ID cannot start with an unescaped >
			my $error_handler = Bio::GFFValidator::ErrorHandlers::IDErrorsHandler->new(
			                    error=>"ID cannot start with an unescaped >");
			$error_handler->handle();
		}
		
	}else{
		# ID cannot be empty
	
	
	}

}






no Moose;
__PACKAGE__->meta->make_immutable;
1;
