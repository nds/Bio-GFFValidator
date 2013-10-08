package Bio::GFFValidator::ErrorHandlers::ParserErrorHandler;
# ABSTRACT: 

=head1 SYNOPSIS


=method 


=cut



use Moose;

use Bio::Root::Exception;

extends 'Bio::GFFValidator::ErrorHandlers::BaseErrorHandler';



has 'exception'        => ( is => 'ro', isa => 'Bio::Root::Exception',  required => 1 );


sub handle
{
  my ($self) = @_;
  
  # With the way the Bio Perl GFF parser throws the exception, we have no choice but to parse
  # the text of the exception to determine what it is
  
  # Example: MSG: [ctg123 . gene            1000  9000  .  +  .  ID=gene00001;Name=EDEN] does not look like GFF3 to me
  #if($self->error =~ m/MSG:\[(\.+)\]does not look like GFF3 to me/){

  if($self->exception =~ m/does not look like GFF3 to me/){
  	$self->report("line","Not a valid GFF3 line as it does not contain 9 tab-delimited values.");
  }else{
    my $message = $self->exception->text(); #{'-text'};
  	$self->report("line", $message);
  
  }
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
