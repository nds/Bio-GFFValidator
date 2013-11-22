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
has 'mode'          => ( is => 'ro', isa => 'Str', default => 'normal'); # test - if you are running dzil tests


sub print {

  my ($self) = @_;
  # For each error, print the error message into the specified error file

  open(my $fh, ">", $self->error_report) or die "Cannot open $self->error_report: $!";
  my $date = Time::Piece->new->strftime('%d/%m/%Y');
  my $time = localtime;

  # Print header of file (if not in test mode)
  if($self->mode eq 'normal') {
  		print $fh "~~ Error report for ".$self->gff_file." ~~ \n";
#   		print STDERR "~~ Error report for ".$self->gff_file." ~~ \n";
  		print $fh "~~ $date, ".$time->hour.":".$time->min.":".$time->sec." ~~\n";
#   		print STDERR "~~ $date, ".$time->hour.":".$time->min.":".$time->sec." ~~\n";
  }
  
  for my $error (@ {$self->errors} ){
  	 
  	 	my $error_message = $error->get_error_message;
  	 	$error_message =~ s/\n+$//; # Incase there are any new lines put in by the error classes....like in the Gene Model Errors class
  		print $fh $error_message,"\n";
#   		print STDERR $error_message,"\n"; # Delete

  }
  
  close($fh);
  
  }


no Moose;
__PACKAGE__->meta->make_immutable;
1;
