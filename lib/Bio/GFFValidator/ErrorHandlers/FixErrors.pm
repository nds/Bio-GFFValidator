package Bio::GFFValidator::ErrorHandlers::FixErrors;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array ref of errors, this tries to fix each one (if the fix_it subroutine has been implemented for that error)

=method 


=cut



use Moose;



has 'errors'        		=> ( is => 'ro', isa => 'ArrayRef',  required => 1 );




sub fix_errors {

  my ($self) = @_;
  
  # Fill in
  
  return $self
  
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
