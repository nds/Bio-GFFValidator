package Bio::GFFValidator::ErrorHandlers::PrintSummary;
# ABSTRACT: 

=head1 SYNOPSIS

Given an array ref of errors, this prints out a summary into a summary file

=method 


=cut



use Moose;
use Time::Piece;

has 'gff_file'				=> ( is => 'ro', isa => 'Str', 	required => 1);
has 'errors'        		=> ( is => 'ro', isa => 'ArrayRef',  required => 1 );
has 'error_summary_report'	=> ( is => 'ro', isa => 'Str', 	required => 1 );
has 'mode'          		=> ( is => 'ro', isa => 'Str', default => 'normal'); # test - if you are running dzil tests

sub print {

  my ($self) = @_;
  
  open(my $fh, ">", $self->error_summary_report) or die "Cannot open ".$self->error_summary_report.": $!";
  my $date = Time::Piece->new->strftime('%d/%m/%Y');
  my $time = localtime;

  # Print header of file (if not in test mode)
  if($self->mode eq 'normal') {
  		print $fh "~~ Error summary report for ".$self->gff_file." ~~ \n";
  		print $fh "~~ $date, ".$time->hour.":".$time->min.":".$time->sec." ~~\n";
  		print $fh "\n";
  }
  
  #TODO: At the moment, we print a count of the errors. Add functionality to do more later. e.g., a count of the different types of errors etc
  print $fh scalar @{$self->errors}." error(s) found in file. \n"; 
  close($fh);
  
  return $self
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;


