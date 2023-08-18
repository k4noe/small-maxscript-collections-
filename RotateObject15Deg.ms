-- Just maxscript for rotating object using Z directory in same or random dir
-- Put it into maxscript startup dir and restart 
-- You can access it in category --> CG_Tools
-- just Assign some shortcut for quick action 
-- theres 2 action 
-- 1: rotate object arround Z in same dir
-- 2 : rotate object arround Z in random dir
-- Work on group , open group member (as individual), or not group member
-- Hope there no error tho

struct rotateTools
(
	fn findGroupHead node =
	(
	if node.parent != undefined then
		(
		if isgrouphead node.parent then return node.parent 
		)
	findGroupHead node.parent
	),

	
	mapped fn rotateSelection sel deg randState = 
	(
		local staticRotation =  eulerangles 0 0 deg
		local rot =  rotate
		
		local min=deg, maxs =360
		local randomRotation = eulerangles 0 0 (random min maxs) 
		
		local rotAngle
		
		if (randState) then 
			(
				rotAngle = randomRotation
			)
		else 
			(
				rotAngle = staticRotation
			)
		
		case of 
		(
			-- inside group and closed 
			(isGroupMember sel and (not (isOpenGroupMember sel))) :
				(
					rot(findGroupHead sel) rotAngle
				)
			
			-- inside group and closed
			(isGroupMember sel and  (isOpenGroupMember sel)) : 
				(
					rot sel rotAngle
				)
			
			-- not group member dan bukan open group member
			(not (isGroupMember sel) and (not (isOpenGroupMember sel))) :
				(
					rot sel rotAngle
				)
		)
	),

	fn executeRot nodeArray deg randState:false = 
	(
		local nodes = (nodeArray as array)
		
		if nodes.count!=0 do
		(
			if randState then 
			(
				with undo on (rotateSelection nodes deg randState)
				
			)
			else 
			(

				with undo on (rotateSelection nodes deg randState)
			)
		)
	)
)


global rotationOPS=rotateTools()

MacroScript rotate90Deg 
category:"CG_Tools" 
tooltip:"Rotate Z 15deg"
buttontext:"Rotate Z 15deg"
(

	on execute do
		(
			rotationOPS.executeRot (selection) 15 randState:false
		)
	
)

MacroScript rotateRandDeg 
category:"CG_Tools" 
tooltip:"Random Rotate Z"
buttontext:"Random Rotate Z"
(

	on execute do
		(
			rotationOPS.executeRot (selection) 5 randState:true
		)
	
)
