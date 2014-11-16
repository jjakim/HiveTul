#!/usr/bin/perl -w
# v0.0.1
#####################
# read Temperature & TEMPerHUM PCSensor devices
#  - ported from BASH file hive.sh 11/14/14 jj
# call: pcsensor.pl( )
# returns: 
# expects: Frodo's tempered at /usr/local/bin/
#####################

use strict;

use Log::Log4perl qw(:easy);

# note about calling: to ease debugging, this routine checks to see if it 
#  has been called from the command line or from a module.
#  IF it has been called from the commandline - logging is set to TRACE (report everything)
#   and output is sent to the console.
#  ELSE it has been called by some other routine, logging 
#   is (set to WARN | inherited) <-- I need to fix this.
#TODO: set logging to inherit from calling routine.

# note about logging:
# logging has six levels of reporting:
#   ALWAYS, FATAL, ERROR, WARN, INFO, DEBUG, and TRACE
#  and take the form LEVEL("message",...)
#  all messages up to and including the level you pick will be reported.

unless (caller){
	#from the commandline
		Log::Log4perl->easy_init( {
		level => $TRACE,
		layout => '%d %m%n' #means: date time message (newline) 
		} );
}else{
	#called
		Log::Log4perl->easy_init( {
		level => $WARN,
		filename => "/home/hivetool/error.log",
		layout => '%d %m%n' #means: date time message (newline) 
		} );	
}

my $logger = get_logger();

### end of housekeeping

my $reply;
my $path;
my @path;
my @device;
my $x;

# walk thru and enumerate available devices
$reply=`/usr/bin/timeout 5 /usr/local/bin/tempered -e`;

$logger->debug("avail devices=\n", $reply );
#expect:
#/dev/hidraw3 : TEMPerV1.2 or TEMPer2V1.3 (USB IDs 0C45:7401)
#/dev/hidraw1 : TEMPer2HumiV1.x (USB IDs 0C45:7402)

#parse paths
$x =1;
while ($reply =~ /.dev.hidraw(\d).*\(USB IDs ([A-Za-z0-9:]{9})\)/g) 
{
$path[$x] = $1;
$device[$x] = $2;
$logger->debug(": path ", $path[$x], " => ", $device[$x],);
$x += 1;
}
