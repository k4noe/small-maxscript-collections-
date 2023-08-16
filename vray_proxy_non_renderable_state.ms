
try (DestroyDialog rendrableOBJ) catch()

rollout rendrableOBJ "makeObjectRenderable" width:162 height:78
(
	button 'btn1' "Make Renderable" pos:[9,9] width:134 height:26 align:#left
	button 'btn2' "Make un-Renderable" pos:[9,41] width:134 height:26 align:#left

	fn collectByType type:VRayProxy = 
	(
		local objs = (for i in objects where iskindof i type collect i )
		objs
	)

	mapped function setObjectRenderable obj state =
	(
		obj.renderable = state
	)

	on btn1 pressed do
	(
		local obj = collectByType()
		setObjectRenderable obj true
		CompleteRedraw()
	)
	
	on btn2 pressed do
	(
		local obj = collectByType()
		setObjectRenderable obj false
		CompleteRedraw()
	)
)

CreateDialog rendrableOBJ
