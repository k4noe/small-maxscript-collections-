clearlistener()

fn collectClassInstance sel  =
(
	local x=#()
	for i in sel do 
	(
		for j in (getClassInstances (classOf i)) do append x j 
	)
	x
)

fn getHeadOfInstance nodes = 
(
	local trueNode  = #()
	local arr = collectClassInstance nodes 

	for x=1 to arr.count do 
	(
		local theX = refs.dependents arr[x]
		--canConvertTo theX[1] Editable_mesh
		local res = for i in (theX) where (isKindOf i geometryClass) or (isKindof i shape) collect i 
		--select res 
		append trueNode  res[1]
	)
	
	trueNode
)

ex: 
select (getHeadOfInstance (selection))
