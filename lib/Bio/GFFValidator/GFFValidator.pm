package Bio::GFFValidator::GFFValidator;
# ABSTRACT: Validates a given GFF file and produces an error report

=head1 SYNOPSIS

Runs the validation checks on the feature objects and gene models produced by the parser

=head1 SEE ALSO

=for :list

=cut

use Moose;

use Cwd;

use Bio::GFFValidator::Parser::Main;
use Bio::GFFValidator::Errors::ID::IDFormatError;
use Bio::GFFValidator::Errors::Parser::ParserError;
use Bio::GFFValidator::ErrorHandlers::PrintReport;


has 'gff_file'        => ( is => 'ro', isa => 'Str',  required => 1 );
has 'error_report'	  => ( is => 'rw', isa => 'Str',  lazy     => 1, builder => '_build_error_report' );
has 'handler_option'  => ( is => 'ro', isa => 'Num', default => 1); # 1 - print errors in a report, 2 - print a summary, 3 - fix errors
has 'errors'		  => ( is => 'rw', isa => 'ArrayRef' );


sub _build_error_report {
  my ($self) = @_;
  return getcwd()."/ERROR_REPORT.txt"; #Include gff file name and date
}

sub error_report_name {
  my ($self) = @_;
  return $self->error_report;

}

sub run {
	my ($self) = @_;
	my $gff_parser = Bio::GFFValidator::Parser::Main->new(gff_file => $self->gff_file);
	my @errors_found;
	
	eval {
		$gff_parser->parse();
	};
	
	# Catch errors thrown by the Bio Perl parser. Will this catch multiple errors?
	if(my $exception = $@){ 
		my $parser_errors = (Bio::GFFValidator::Errors::Parser::ParserError->new(exception => $exception))->validate();
		push(@errors_found, $parser_errors);
	}
	
	if($self->handler_option == 1){ # Print errors into a report
		my $report_printer = Bio::GFFValidator::ErrorHandlers::PrintReport->new(
																errors => \@errors_found,
																error_report => $self->error_report);
		$report_printer->print();
	}
	

   return $self;
   
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
