clearlistener()

mapped fn collectClassInstance sel &inst =
(
	for j in (getClassInstances (classOf sel)) do appendIfUnique inst j 
		
)

fn getHeadOfInstance sel = 
(
	local trueNode  = #(),arr=#()
	local _arr = collectClassInstance sel &arr  

	for x=1 to arr.count do 
	(
		local theX = refs.dependents arr[x]
		--canConvertTo theX[1] Editable_mesh
		local res = for i in (theX) where ((isKindOf i geometryClass) or (isKindof i shape)) collect i 
		--select res 
		append trueNode  res[1]
	)
	trueNode
)
