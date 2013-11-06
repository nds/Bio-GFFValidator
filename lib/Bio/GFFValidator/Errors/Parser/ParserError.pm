package Bio::GFFValidator::Errors::Parser::ParserError;
# ABSTRACT: 

=head1 SYNOPSIS

Reads in a GFF file using Bio Perl and generates an array of feature objects and an array of gene models

=method 


=cut

use Moose;

use Bio::Root::Exception;

extends 'Bio::GFFValidator::Errors::BaseError';

has 'exception'        => ( is => 'ro', isa => 'Bio::Root::Exception',  required => 1 );


sub validate {

  my ($self) = @_;
  
  # With the way the Bio Perl GFF parser throws the exception, we have no choice but to parse
  # the text of the exception to determine what it is in most cases. In some cases, it throws
  # a typed exception in which case we can extract the text
  
  # Example: MSG: [ctg123 . gene            1000  9000  .  +  .  ID=gene00001;Name=EDEN] does not look like GFF3 to me
  #if($self->error =~ m/MSG:\[(\.+)\]does not look like GFF3 to me/){
  
  my $exception_message;
  if($self->exception->text()){
  	$exception_message = $self->exception->text();
  }else{
  	$exception_message = $self->exception;
  }
  
  print STDERR $self->exception." \n";
  
  
  # Switch behaviour can be unpredictable and there is some talk of it being depracated. So sticking to simple if/else structure below

  if($exception_message =~ m/(\S+) does not look like GFF3 to me/){
  	 $self->set_error_message("line_number", $1 , "Not a valid GFF3 line as it does not contain 9 tab-delimited values.");
  }elsif($exception_message =~ m/\'\' is not a valid/){
  	 $self->set_error_message("line_number", "value", "Empty fields cannot be left blank. They must have a dot.");
  }elsif($exception_message =~ m/(\S+) is not a valid frame/){
  	 $self->set_error_message("line_number", "value", "$1 is not a valid phase. Should be one of ., 0, 1 or 2");
  }elsif($exception_message =~ m/Failed validation of sequence/){
  	 $self->set_error_message("line_number", "value", "Failed to validate sequence. Is there an unescaped > character at the start of a feature line?");
  }else{
  	 $self->set_error_message("line_number", "value", $exception_message); #All Bio Perl errors that we have not dealt with yet
  }
  
  return $self;
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
