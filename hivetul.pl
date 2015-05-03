#!/usr/bin/perl -w

# ##############################################################################
#                         hive.pl ver 0.1
#
# Reads hive variables, logs them and generates plots
# (future development) sends the data to hivetool.net
# pure perl implementation 4/7/15 jj
#
#
# perl will need:
# log::Lo4perl
#
# ##############################################################################
#

use strict;
use warnings;

use Log::Log4perl qw(:easy);

#TODO: clean up the logger configuration.

#initialize logger
my $log_conf = "/home/pi/logger.conf"; # q(
#log4perl.rootlogger		=INFO, LOG1
#log4perl.appender.LOG1	=Log::Log4perl::Appender::File
#log4perl.appender.LOG1.filename	=/home/pi/error.log
#log4perl.appender.LOG1.mode	=append
#log4perl.appender.LOG1.layout	=Log::Log4perl::Layout::PatternLayout
#log4perl.appender.LOGFILE.layout.ConversionPattern	=%D %L %c - %m%n
#);

Log::Log4perl->init($log_conf);
#TODO: errors are not redirected to log4perl
# note about logging:
# logging has six levels of reporting:
#   ALWAYS, FATAL, ERROR, WARN, INFO, DEBUG, and TRACE
#  and take the form LEVEL("message",...)
#  all messages up to and including the level you pick will be reported.

my $logger = Log::Log4perl->get_logger();



# Set the hive name(s)
my $HIVE1_NAME = "XP005";

# Set the TEMPerHUM devices
# To see the devices, run tempered with no argument
#


# Set the Weather Underground weather station ID
#
#my $WX_ID="KCAPLACE34";
#Observatory
#my $WX_ID="C6129";
#

my $HIVE1_TEMP_DEVICE = "/dev/hidraw1";
my $HIVE1_AMBIENT_TEMP_DEVICE = "/dev/hidraw3";
# zero out variables
my $HIVE1_WEIGHT       = 0;
my $HIVE1_TEMP         = 0;
my $HIVE1_HUMIDITY     = 0;
my $HIVE1_AMBIENT_TEMP = 0;
my $TEMPerHUMstr       = "";
my $wx_xml             = "";
my $rrd;
my $loop_cnt = 0;
my $datestr;
my $csvlog;
my $data_good=0;
my $counter=1;
my $weight;
my $hx711_zero=0;
my $hx711_slope=20000;

$datestr = localtime();

# ### END OF SETUP ###

#
# Read scale 1
#
#$HIVE1_WEIGHT = 1383171; # dummy value for debugging.
#$HIVE1_WEIGHT = $HIVE1_WEIGHT / 20000;    # approx. between 20k & 20121
#
# read the scale

while ( $counter < 5 && $data_good == 00){
$weight = `sudo /usr/bin/timeout 5 /home/pi/hx711/hx711 $hx711_zero`;
if ($weight) {
$data_good=1;
}
else
{
$counter++;
$logger->warn( $datestr, "hx711 looped ", $counter );
}
}
$HIVE1_WEIGHT=($weight / $hx711_slope);

# Read hive 1 inside temp and humidity
#
$loop_cnt = 0;
$TEMPerHUMstr       = "";
while ( $TEMPerHUMstr eq "" ) {
	$loop_cnt += 1;
	if ($loop_cnt >= 2){
#		print ".";	
		sleep 10;
		 	}
	if ( $loop_cnt > 5 ) { last;
		 }
	EVAL{$TEMPerHUMstr = `sudo tempered /dev/hidraw3`} or next;
	# print "-",$TEMPerHUMstr,"-\n";
	$TEMPerHUMstr =~ /temp[A-Za-z]+\s(\d+\.\d+)/;
	$HIVE1_TEMP = $1;
	$TEMPerHUMstr =~ /humid[A-Za-z]+\s(\d+\.\d+)/;
	$HIVE1_HUMIDITY = $1;
}
if ( $loop_cnt > 2 ) {
	$logger->warn( $datestr, "IntTemp looped ", $loop_cnt );
	$HIVE1_TEMP     = -99;
	$HIVE1_HUMIDITY = -99;
}
# print "loop1= ", $loop_cnt, "\n";

# Read hive 1 outside temp
#
$loop_cnt = 0;
$TEMPerHUMstr = "";
while ( $TEMPerHUMstr eq "" ) {
	if ($loop_cnt >= 1){
		print ".";	
		sleep 10;
		 	}
	$TEMPerHUMstr = `sudo tempered /dev/hidraw1`;
	# print "--",$TEMPerHUMstr,"--\n";
	
	$TEMPerHUMstr =~ /1: temp[A-Za-z]+\s(\d+\.\d+)/;
	$HIVE1_AMBIENT_TEMP = $1;
	$loop_cnt += 1;

	if ( $loop_cnt > 5 ) { last;
		 } 
		 	
		 
}
if ( $loop_cnt > 2 ) {
	$logger->warn( $datestr, "ExtTemp looped ", $loop_cnt );
	$HIVE1_AMBIENT_TEMP = -99;
}
# print "loop2= ", $loop_cnt, "\n";


# File gets too big - too quick.
#$csvlog = '/home/pi/hivetul.csv';
#open(my $fh, '>>', $csvlog ) or $logger->info( $datestr, "unable to open csvfile" );
#print $fh $datestr,", ",$HIVE1_WEIGHT,", ", $HIVE1_TEMP, ", ",$HIVE1_HUMIDITY, ", ",$HIVE1_AMBIENT_TEMP, "\n";
#close $fh;

$rrd =
`sudo /usr/bin/rrdtool update /home/pi/hivetul.rrd N:$HIVE1_WEIGHT:$HIVE1_TEMP:$HIVE1_HUMIDITY:$HIVE1_AMBIENT_TEMP`;

#print $rrd, "\n";  #no response??
#log everything
	$logger->info($datestr,", ",$HIVE1_WEIGHT,", ", $HIVE1_TEMP, ", ",$HIVE1_HUMIDITY, ", ",$HIVE1_AMBIENT_TEMP, "\n" );

##
## Write everything to hive 1 log file
#
#echo -ne "\n"$DATE $HIVE1_WEIGHT $HIVE1_TEMP $HIVE1_AMBIENT_TEMP $temp_f $wind_dir $wind_mph $wind_gust_mph $dewpoint_f $relative_humidity $pressure_mb $solar_radiation $WX_EVAPOTRANSPIRATION $WX_VAPOR_PRESSURE $precip_today_in>> /home/hivetool/$HIVE1_NAME.log
#

#
#source /home/hivetool/sql.sh
#

#Run the graphing program to create index.html and hive_graph.gif
# this
#/var/www/htdocs/graph_hive.pl
#  will have to be changed to something like this:
#/var/www/htdocs/graph_hive.pl -l /home/hivetool/$HIVE1_NAME -o /var/www/htdocs/$HIVE1_NAME
#/var/www/htdocs/graph_hive.pl -l /home/hivetool/$HIVE2_NAME -o /var/www/htdocs/$HIVE2_NAME
#
#

# Create hive1 xml data file
#
# ### the variable names in xml.sh need to be changed so most of these assignments won't be necessary
#
##HOST=$HIVE1_NAME
#SCALE=$HIVE1_WEIGHT
#TEMP=$HIVE1_TEMP
#AMBIENT=$HIVE1_AMBIENT_HUMIDITY
#HUMIDITY=$HIVE1_HUMIDITY
#HUMIDITY_2=$HIVE1_AMBIENT_HUMIDITY
#echo "<hive_data>" > /tmp/hive1.xml
#source /home/hivetool/xml.sh >> /tmp/hive1.xml
#cat /tmp/wx.xml|grep -v "xml" >> /tmp/hive1.xml
#echo "</hive_data>" >> /tmp/hive1.xml
#
# Send hive1 data to hivetool
#
#/usr/bin/curl --retry 5 -k -u user:passwd -X POST --data-binary @/tmp/hive1.xml https://hivetool.org/private/log_hive.pl  -H 'Accept: application/xml' -H 'Content-Type: application/xml' 1>/tmp/hive_command.xml
#
