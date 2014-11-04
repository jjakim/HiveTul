#!/usr/bin/perl -w


#####################
# read the HX711 scale
#  - ported from BASH 11/4/14 jj
# call: hx711.pl( zero, slope )
# returns: weight in lbs.
#####################

use strict;

use Log::Log4perl qw(:easy);

# note about logging:
# logging has six levels of reporting:
#   ALWAYS, FATAL, ERROR, WARN, INFO, DEBUG, and TRACE
#  and take the form LEVEL("message",...)
#  all messages up to and including the level you pick will be reported.

Log::Log4perl->easy_init( {
	level => $WARN,
#	filename => "/home/hivetool/error.log"
	layout => '%d %m%n' #means: date time message (newline) 
	} );
my $logger = get_logger();

my $hx711_zero;
my $hx711_slope;

if ($#ARGV != 1 ) {
    print "Parameter count: ", $#ARGV +1;
	print " ...usage: hx711 zero slope\n";
	exit;
}

$hx711_zero = $ARGV[0];
$hx711_slope = $ARGV[1];

$logger->debug( "zero= ", $hx711_zero, "  slope= ", $hx711_slope);

# read the scale
my $data_good=0;
my $counter=1;
my $weight;

while ( $counter < 5 && $data_good == 00){
$weight = `sudo /usr/bin/timeout 5 /home/pi/hx711/hx711 $hx711_zero`;
$logger->debug( $weight );
if ($weight) {
$data_good=1;
}
else
{
$counter++;
}
}
$weight=($weight / $hx711_slope);

$logger->debug( $counter );
$logger->debug($weight );

#if [[ $COUNTER -gt 10 ]]
#then
#  echo "$DATE ERROR reading Scale $DEVICE" >> /home/hivetool/error.log
#  SCALE=-555
#fi

#if test $COUNTER -gt 2
#then
#  echo "$DATE WARNING reading Scale /dev/ttyS0: retried $COUNTER" >> /home/hivetool/error.log
#fi

#return $weight;
print $weight;
