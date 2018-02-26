# kdb-haversine
Screaming fast geo-near, and radius queries using KDB+, the world's fastest number cruncher from https://kx.com.
---  
## What does it do?
This is a trivially simple function that, for 2 pairs of _lat/lon_ points on the earth's surface, returns an accurate( for most use cases ) value of the distance between them, using _q_, the language of the KDB+ platform. The applied _haversine formula_ is nothing new, but it's presented here in a way that allows it to perform fast under heavy load at scale.
### How could I use it and what for?
The basic _haversineDistance_ function does a fairly trivial job:  
It provides a distance in km between two points. If that's your use case, then you're all done. But, frankly computing the distance bewteen two points is fairly straightforward - several implementations of the formula can be viewed [here](http://www.movable-type.co.uk/scripts/latlong.html "Calculate distance, bearing and more between Latitude/Longitude points"). The value of a _q_ implementation comes from the power and raw speed of KDB+, which can operate over literally billions of rows per second.
###Simple Invocation
The function, standalone takes 4 parameters lat1, lon1, lat2, lon2, corresponding to 2 _lat/lon_ pairs. To use it:

`haversineDistance[lat1; lon1; lat2; lon2]`

As an example, to calculate the distance from London to Oxford, UK, you'd simply call:

`haversineDistance[51.5085300;-0.1257400;51.7517;-1.2553]`

### Adding functionality
Once we have a distance between 2 points supplied by a q function, some interesting possibilies open up. Let's define a trivial _q_ function that accepts not 4, but 5 parameters:

`myOutOfRangeFunction:{[radius; lat1; lon1; lat2; lon2]radius < (haversineDistance[lat1; lon1; lat2; lon2])}`

This will return true if the distance between point 1 and point 2 is greater than the supplied radius / threshold. It'll also do it a blazing speed.

### Integration with  data in KDB+
So, we can extend the basic _haversineDistance_ function by writing simple functions to see if X is near Y, in range of Y or out of range of Y. Quite useful; but it's a pretty low bar. Let's imagine the following application scenario:

Our Users have Cars. Those Cars emit _events_ such as FUEL-LEVEL-EVENT, SPEEDOMETER-EVENT etc. They also emit a GPS-EVENT, telling us where their Cars are from minute to minute. 
Now, our KDB+ database contains, conveniently, the following tables:

#### Table 1: Makes, Models, Years
	```makeModelYearTable:([vin]make; model; year; kmPerGallon; tankSize)```
#### Table 2 Gas Stations & Locations
	```gasStationTable:([station_id_]lat; lon; companyName; fuelBrand; openingHour; closingHour)```
	
So, let's imagine that we receive a GPS-EVENT for vehicle with vin (unique vehicle id numbering system) 12345500 with position [51.5085300;-0.1257400], and a few seconds later we receive for the same vehicle a FUEL-LEVEL-EVENT with fuelLevel = 0.5 gallons. 

In KDB+ we can easily determine, based on our User's vin, and our Makes, Models, Years table that the tank will soon be empty, based on the event we just captured. When this happens, we can immediately query our Gas Stations & Locations table, including the haversineDistance[GPS-EVENT lat; GPS-EVENT lon; STATION lat; STATION lon] function with radius parameter. We can alert our User that fuel will soon run out, and provide the nearest filling station. 

What KDB+ brings to this scenario is the ability to run millions of such queries per second and push the notifications to whoever needs to have them. It's an interesting candidate for your IoT platform, perhaps even more so with a sprinkling of Geolocation?
