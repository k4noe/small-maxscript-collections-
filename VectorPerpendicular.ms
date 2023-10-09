-- Calculate the midpoint between point A and point B

fn insertPointPerpendicular pA pB pC = 
(
	pD = (pA + pB) / 2

	-- Calculate the direction vector from point C to point D
	directionVector = normalize(pD - pC)

	distanceAB = distance pA pA
	linearFactor = 0.5
	pointD = pA + (pB - pA) * linearFactor
	distanceCD = distance pC pD
	pD = pC + (directionVector * distanceCD)
)
-- Create point D in 3ds Max

pointA = [-30,0,25.9759]
pointB = [20, -60, 0]
pointC = [-30,-60,11.4017]

p1 = point pos:pointA  wirecolor:green
p2 = point pos:pointB  wirecolor:green
p3 = point pos:pointC  wirecolor:green

posD = insertPointPerpendicular (p1.pos) (p2.pos) (p3.pos)
format "Point D: %\n" posD

D = point pos:posD wirecolor:red

-- Output the coordinates of point D

