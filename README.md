#HiveTul
=======

A port of the HiveTool into perl.
It began as a discussion with the original author (villagefool) without whom, I would not have tackled this project. He questioned his current code language, I said I thought the mix was right. But like so much else, I could not stop thinking about it. So I thought to take a crack at it.
The name is a corruption of the original name. 

##ReadMe 
- jjakim hivetul - perl implementation of Hivetool.

Ok, I guess I should call this 'second generation' or some-such.

For starts, I munged the code for simplicity. So I ditched the sql database in favor of RRD. I added log4perl - both for logging (duh) and for the RRD plugin. I figured that weather is archived and recorded in enough *other* places, I didn't need to look it up and store it here. Besides, every stinkin' wunderground site had a different dataset. And after my first installed and working system, I felt that the temperature and humidity had long term research value - but told me nothing day-to-day. Besides the PCSensors were $25 each.

What I was left with was a scale - just a scale, and the focus to target the mythical sub-$100 scale. I believe I have achieved that, IF you don't count the time and manpower. So a 'hacker' or 'maker' can put one together for sub$100. Next (for me, at least) is a comercial, or ready-for-commercial implementation. 

Ok, so what HAVE I done? Well stop over to joggingbuddha.net where I have some of my results (This past year I had a problem with robbing bees - so I have not been as active as I would like.) Heres the link: [link removed - hosting service corrupted the SQL database behind the blog and lost the site, I decided to not send them any more money].
...
...

ok, here are some 'release notes' - I'm still getting comfortable with git.
So far (12/14)
-HX711.pl - read the first side of the two input card. pinout set to my system, may need customazation for you.
-PCSensor.pl - trying to read more than just one of the PCSensor products. Able to read model number, have not set up special routines for each model found.
