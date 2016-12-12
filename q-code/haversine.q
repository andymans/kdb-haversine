//------------GLOBALS------------//

/ First, declare to KBD+ that we're not forcing any precision on any floats we may use.

\P 0

//------------VARIABLES------------//

/ Declare pi and assign it a value. 
/ (btw, out of the box KDB+ doesn't know what 'pi'is; but we can fix that!)

pi: acos -1 

/ Declare the radius of the Earth (in kilometres), and assign it a value. 

radiusInKilometres: 6371


//------------HELPER FUNCTIONS------------//
/ (calculating a haversine distance in 1 code block is moderately complex, so it's useful to break the functionality out into smaller blocks)

/ Function: atan2 - a helper for returning fast atan2 (arctangent) values, given inputs of 'x' and 'y'

atan2:{atan[(x % y)]}

/ Function: atan2SquareRoots - a helper for returning the arctangent of the sqrt of 'x' and the sqrt value of 1-x

atan2SquareRoots:{atan2[sqrt(x); sqrt((1-x))]}

/ Function: sinP - a helper for returning the product P of two sines of 'x' / 2

sinP:{sin((x%2))*sin((x%2))}

/ Function: toRadians - a helper function that converts numbers passed as param 'x' to radian.

toRadian:{pi * x % 180}

//------------HAVERSINE FUNCTION------------//

/ Function: haversineDistance - returns a distance between two points (lat/lon pairs) that is useably accurate for a large number of use cases
/ params - w, x represent lat/lon pair 1, while y, z correspond to  lat/lon pair 2 

haversineDistance:{[w;x;y;z]
	radiusInKilometres*(2*atan2SquareRoots[(sinP[(toRadian[((y)-(w))])]+sinP[(toRadian[((z)-(x))])]*(cos(toRadian[w]))*(cos(toRadian[y])))])
	}


/ How To Use:
/ Simply call the function by invoking 'haversineDistance[lat1;lon1;lat2;lon2]' either in your code or on the q command line

/ Example - the following call returns the distance in km between London and Oxford in the UK

/ haversineDistance[51.5085300;-0.1257400;51.7517;-1.2553]

/ Tip - to learn more about the maths behind the haversine function - take a look at http://www.movable-type.co.uk/scripts/latlong.html

