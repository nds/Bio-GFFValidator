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

  if($self->exception =~ m/does not look like GFF3 to me/){
  	 $self->line("line number");
  	 $self->value("value");
  	 $self->message("Not a valid GFF3 line as it does not contain 9 tab-delimited values.");
  }else{
     my $message = $self->exception->text(); #{'-text'};
  	 $self->line("line number");
  	 $self->value("value");
  	 $self->message($message);
  
  }
  
}




no Moose;
__PACKAGE__->meta->make_immutable;
1;
