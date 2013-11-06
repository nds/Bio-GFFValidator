package Bio::GFFValidator::ErrorHandlers::PrintReport;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array ref of errors, this prints out all the error messages into an error report.

=method 


=cut



use Moose;
use Time::Piece;


has 'gff_file'		=> ( is => 'ro', isa => 'Str', 	required => 1);
has 'errors'        => ( is => 'ro', isa => 'ArrayRef',  required => 1 );
has 'error_report'	=> ( is => 'ro', isa => 'Str', 	required => 1);


sub print {

  my ($self) = @_;
  # For each error, print the error message into the specified error file

  open(my $fh, ">", $self->error_report) or die "Cannot open $self->error_report: $!";
  my $date = Time::Piece->new->strftime('%d/%m/%Y');
  my $time = localtime;

  # Print header of file
  print $fh "~~ Error report for ".$self->gff_file." ~~ \n";
  print STDERR "~~ Error report for ".$self->gff_file." ~~ \n";
  print $fh "~~ $date, ".$time->hour.":".$time->min.":".$time->sec." ~~\n";
  print STDERR "~~ $date, ".$time->hour.":".$time->min.":".$time->sec." ~~\n";
  
  for my $error (@ {$self->errors} ){
  	  	if($error->triggered){
  		print $fh $error->get_error_message;
  		print STDERR $error->get_error_message; # Delete
  	}  
  }
  
  close($fh);
  
  }


no Moose;
__PACKAGE__->meta->make_immutable;
1;
