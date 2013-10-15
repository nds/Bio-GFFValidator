package Bio::GFFValidator::ErrorHandlers::PrintReport;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array ref of errors, this prints out all the error messages into an error report.

=method 


=cut



use Moose;



has 'errors'        => ( is => 'ro', isa => 'ArrayRef',  required => 1 );
has 'error_report'	=> ( is => 'ro', isa => 'Str', 	lazy => 1,	 builder => '_build_output_filename' );


sub _build_output_filename {
  my ($self) = @_;
  return getcwd()."/ERROR_REPORT.txt";
}


sub print {

  my ($self) = @_;
  # For each error, print the error message into the specified error file
  # We should be sent an error file name that includes the name of the GFF file, the date and in the 
  # relevant directory. If not we produce, ERROR_REPORT.txt in the current directory.

  open(my $fh, ">", $self->error_report) or die "cannot open $self->error_report: $!";

  # Print header of file
  print $fh "Error report - testing\n";


  for my $error (@ {$self->errors} ){
  	
  	if($error->triggered){
  		print $fh $error->get_error_message."\n";
  		print STDERR $error->get_error_message."\n"; # Delete
  	}
  	
  
  }
  
  close($fh);
  
  
}

sub error_report_name {
	my ($self) = @_;
	return $self->error_report;

}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
