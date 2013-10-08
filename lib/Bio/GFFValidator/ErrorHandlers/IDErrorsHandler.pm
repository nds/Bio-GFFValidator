package Bio::GFFValidator::ErrorHandlers::IDErrorsHandler;
# ABSTRACT: 

=head1 SYNOPSIS


=method 


=cut



use Moose;

extends 'Bio::GFFValidator::ErrorHandlers::BaseErrorHandler';

has 'error'        => ( is => 'ro', isa => 'Str',  required => 1 );


sub handle
{
  my ($self) = @_;
  	$self->report("line", $self->error);
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
