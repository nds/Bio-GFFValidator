package Bio::GFFValidator::CommandLine::GFF_Validator_Commandline;

# ABSTRACT: Validate the arguments sent via the gff_validator.pl script and run the validator

=head1 SYNOPSIS

Validate the arguments sent via the gff_validator.pl script and run the validator


=cut

use Moose;
use Cwd;
use File::Basename;

has 'gff_file'        	=> ( is => 'ro', isa => 'Maybe[Str]');
has 'output_option' 	=> ( is => 'ro', isa => 'Maybe[Num]',      default => 1 );
has 'error_file' 		=> ( is => 'rw', isa => 'Maybe[Str]'); 
has 'help'        		=> ( is => 'rw', isa => 'Maybe[Bool]',     default  => 0 );

has '_error_message' 	=> ( is => 'rw', isa => 'Str');

## Validate arguments 

sub BUILD {
    my ($self) = @_;
	
	# The user has to specify a gff file
	if(not defined($self->gff_file)){
		$self->_error_message("Error: You need to provide a GFF file.");
		$self->_die_and_print_usage();
	}
	# Only accept gff files, unzipped gff files
	if($self->gff_file !~ /\.gff$/ || $self->gff_file !~ /\.gff3$/){
		$self->_error_message("Error: You need to provide a GFF file (unzipped).");
		$self->_die_and_print_usage();
	}
	
	# Output_option can only be 1,2 pr 3
	if($self->output_option !~ /[123]/ ){
		$self->_error_message("Error: The output option can only be 1,2 or 3.");
		$self->_die_and_print_usage();
	}
	
	# If help, display usage
	if($self->help){
		$self->_die_and_print_usage();
	}
	
	# If the error file has not been specified, we revert to default
	if(not defined($self->error_file)){
		$self->error_file(getcwd()."/".basename($self->gff_file).".ERROR_REPORT.txt"); 
	}

}

## Run the validator and print a line to inform user of what has happened

sub run {
  	my ($self) = @_;
  	
  	my $gff_validator = Bio::GFFValidator::GFFValidator->new(
   		gff_file =>  $self->gff_file,
   		error_report => $self->error_file,
   		handler_option => $self->output_option,
	)->run;
  	
  	if($gff_validator->status){
		print "Errors reported in ".$self->error_file."\n";
	}else{
		print "No errors found. \n";
	}
  
}

sub _die_and_print_usage {
	my ($self) = @_;
	
	if($self->_error_message){
		print $self->_error_message, "\n";
	}
	die <<USAGE;
	
	Usage: gff_validator.pl [options]
	
		-f|gff_file        <gff file>
		-o|output_option   <output option (1 (default): error report 2: summary 3: fix errors)>
		-e|error_file	   <name of error file (default is gff_file_name.ERROR_REPORT in current working directory)>
		-h|help      	   <this message>

Takes in a gff file and validates it. Depending on the -o option, it can either print an error report (default), print a summary or fix the errors found (not implemented yet)

# Outputs an error file in the current working directory. The error file will be named using the GFF file's name
gff_validator -f myfile.gff

USAGE

}



__PACKAGE__->meta->make_immutable;
no Moose;
1;