HiveTul
=======

A port of the HiveTool into perl.
It began as a discussion with the original author (villagefool) without whom, I would not have tackled this project. He questioned his current code language, I said I thought the mix was right. But like so much else, I could not stop thinking about it. So I thought to take a crack at it.
The name is a corruption of the original name. 

ReadMe - jjakim hivetul - perl implementation of Hivetool.

Some philosophy first:
Each of the modules are written such that they can be run from the command line 
as well as being called from within the app. This means that there are no assumptions 
and that each routine is truly atomic. Note that they do need log:Log4Perl to be loaded.

This is a 'lite' implementation. The database only stores 'original' information. 
The weather is well recorded elsewhere, and the precise values at any given moment are not 
worth the data handling overhead. I found that *what* data is available varied and *how* it
is presented is highly dependent on which WeatherUnderground site was queried. So that 
information is not recorded by this implementation.

So far (12/14)
-HX711.pl - read the first side of the two input card. pinout set to my system, may need customazation for you.
-PCSensor.pl - trying to read more than just one of the PCSensor products. Able to read model number, have not set up special routines for each model found.
