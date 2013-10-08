package Bio::GFFValidator::ErrorHandlers::BaseErrorHandler;
# ABSTRACT: 

=head1 SYNOPSIS

Base Error handler class

=method 


=cut



use Moose;

sub handle {

}

sub report
{
  my ($self, $value, $message) = @_;
  print STDERR "ERROR: [$value] $message\n";
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
