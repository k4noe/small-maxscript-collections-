clearlistener()

fn filterObject node =
(
	isKindOf i geometryClass OR \
	isKindof i shape
)

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
		local res = for i in (theX) where (filterObject i) collect i 
		append trueNode  res[1]
	)
	trueNode
)

--ex: 
select (getHeadOfInstance (selection))
