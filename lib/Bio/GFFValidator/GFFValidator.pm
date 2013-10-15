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
use Bio::GFFValidator::Errors::Start_and_End::NotWithinRangeError;
use Bio::GFFValidator::Errors::Start_and_End::NotPositiveIntegerError;
use Bio::GFFValidator::Errors::Start_and_End::StartNotLessThanEndError;
use Bio::GFFValidator::Errors::Strand::StrandNotInRightFormatError;
use Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError;
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
	
	# Catch errors thrown by the Bio Perl parser. This still dies - do some monkey patching of Bio::Root::Exception!!!
	if(my $exception = $@){ 
		my $parser_errors = (Bio::GFFValidator::Errors::Parser::ParserError->new(exception => $exception))->validate();
		push(@errors_found, $parser_errors);
	}
	

	# Run the tests for each of the features
	my $arrayref = $gff_parser->features;
	for my $feature (@$arrayref){
		# ID errors (column 1)
	
	
		# Start and end (columns 4 and 5)
		my $notpositiveinteger_error = (Bio::GFFValidator::Errors::Start_and_End::NotPositiveIntegerError->new(feature => $feature))->validate();
		push(@errors_found, $notpositiveinteger_error);
		my $startnotlessthanend_error = (Bio::GFFValidator::Errors::Start_and_End::StartNotLessThanEndError->new(feature => $feature))->validate();
		push(@errors_found, $startnotlessthanend_error);
		my $notwithinrange_error = (Bio::GFFValidator::Errors::Start_and_End::NotWithinRangeError->new(feature => $feature, seq_regions => $gff_parser->seq_regions ))->validate();
		push(@errors_found, $notwithinrange_error);
		
		# Score (column 6) - no checks at the moment as specification sketchy
		
		# Strand (column 7) 
		my $strandnotinrightformat_error = (Bio::GFFValidator::Errors::Strand::StrandNotInRightFormatError->new(feature => $feature))->validate();
		push(@errors_found, $strandnotinrightformat_error);
		
		# Phase (column 8)
		my $cdsmissingphase_error = (Bio::GFFValidator::Errors::Phase::CDSFeatureMissingPhaseError->new(feature => $feature))->validate();
		push(@errors_found, $cdsmissingphase_error);
	}
	
	if($self->handler_option == 1){ # Print errors into a report
		my $report_printer = Bio::GFFValidator::ErrorHandlers::PrintReport->new(errors => \@errors_found,error_report => $self->error_report);
		$report_printer->print();
	} # Else, print summary or get the validator to fix errors 
	

   return $self;
   
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
