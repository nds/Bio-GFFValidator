package Bio::GFFValidator::ErrorHandlers::PrintSummary;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array ref of errors, this prints out a summary

=method 


=cut



use Moose;



has 'errors'        		=> ( is => 'ro', isa => 'ArrayRef',  required => 1 );
has 'error_summary_report'	=> ( is => 'ro', isa => 'Str', 	lazy => 1,	 builder => '_build_output_filename' );


sub _build_output_filename {
  my ($self) = @_;
  return getcwd()."/ERROR_SUMMARY_REPORT.txt";
}


sub print {

  my ($self) = @_;
  
  # Fill in
  
  return $self
  
}

sub error_summary_report_name {
	my ($self) = @_;
	return $self->error_summary_report;

}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
