
try (DestroyDialog displayVMesh) catch()
clearListener()

rollout displayVMesh "V-Proxy Tools" width:159 height:265
(
	local listName= #("Preview from file (Face)",\
		"Point",\
		"Preview from file (Edge)",\
		"Whole mesh",\
		"BoundingBox"
		)
		
	local previewList=#("None" , "Dot" , "Box", "WireBox" , "Full","PointCloud")
		
		
		
	dropdownList 'ddl1' "Selected Proxy" pos:[4,4] width:146 height:41 items:listName align:#left
	button 'btn2' "Set All Proxie Preview" pos:[6,52] width:146 height:19 align:#left	
	
	
	
	button 'btn3' "HideProxies" pos:[5,91] width:146 height:19 align:#left
	button 'btn4' "Show Proxies" pos:[5,111] width:146 height:19 align:#left
	button 'btn5' "Show All Mesh Proxy" pos:[5,131] width:146 height:19 align:#left	
	
	
	button 'btn6' "ClearSelection" pos:[6,72] width:146 height:18 align:#left
	
	dropDownList 'ddl2' "DropDownList" pos:[4,157] width:146 height:41 align:#left items:previewList
	
	button 'btn7' "Hide Scatter" pos:[5,224] width:146 height:17 align:#left
	button 'btn8' "Show Scatter" pos:[5,242] width:146 height:17 align:#left
	button 'btn9' "Set Preview" pos:[5,202] width:146 height:21 align:#left	
		

	fn filterVProxyObject node =
	(
		isKindOf node VRayProxy
	)

	fn filterScatterObject node = 
	(
		isKindOf node ChaosScatter
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
			local res = for i in (theX) where (filterVProxyObject i) collect i 
			append trueNode  res[1]
		)
		trueNode
	)
		
		
	fn collectVrayProxies onlySel:true includeChild:false =
	(
		 xx =#()
		
		case onlySel of 
		(
			true : 	(
						getHeadOfInstance (selection as array)
					)

			false : (
						nodeInstance=getClassInstances VRayProxy processAllAnimatables:true 
					
						for i in nodeInstance do 
						(
							 nodes = refs.dependents i --nodeInstance[1]
							
							if includeChild then  
							(
								for j in nodes where (filterVProxyObject j) do appendIfUnique xx j
								--xx
							)
							else 
							(
								if nodes.count!=0 do 
								(
									if (iskindOf (_nodes=nodes[1]) VRayProxy) do 
									(
										appendIfUnique xx _nodes
									)
									
								)
							)
							
						)
					)
		)
		xx 
	)
	
	fn caseDisplay sel intN=
	(
		case of 
		(
			(filterVProxyObject sel ) 	: (sel.display =intN)
			(filterScatterObject sel )	: (sel.displayMode = intN-1)
		)
	)
	
	fn collectAllVProxies selClass:VRayProxy = 
	(
		local _newObject  = #()
		if (selClass == VRayProxy ) then 
			(
				_newObject = collectVrayProxies onlySel:false 
			)
		else 
		(
			_newObject = for i in objects where (isKindOf i selClass) collect i 
		)
		_newObject
	)
	
	
	fn hideProxy sel state:true = 	
	(
		if (state==true) then 
		(
			hide sel  
		)
		else 
		(
			unhide sel 
		)
		
	)
		
	mapped fn changeSelectionDisplay sel intN = 
	(
		caseDisplay sel intN
		
	)
	
	
	fn getAutoSelection = 
	(
		local sels = #()
		
		if selection.count!= 0 then 
		(
			sels = collectVrayProxies onlySel:true includeChild:false
		
		)
		else 
		(
			sels = collectVrayProxies onlySel:false includeChild:true
		)
		sels
	)

	
	on btn2 pressed do -- box prox
	(
		local pr = collectAllVProxies()
		with undo off
			(
				DisableSceneRedraw()
				changeSelectionDisplay pr (ddl1.selection)
				enableSceneRedraw()
				--CompleteRedraw()
			)
			
	)
	on btn3 pressed do --hide prox
	(
		local pr = getAutoSelection()
		with undo off 
			(
				DisableSceneRedraw()
				hideProxy pr state:true
				enableSceneRedraw()
			)
		--CompleteRedraw()
	)
	on btn4 pressed do -- show prox
	(
		local pr = getAutoSelection()
		with undo off 
			(
				DisableSceneRedraw()
				hideProxy pr state:false
				enableSceneRedraw()
			)
		--CompleteRedraw()	
	)
	on btn5 pressed do -- box prox
	(
		local pr = getAutoSelection()
		with undo off 
			(
				DisableSceneRedraw()
				changeSelectionDisplay pr 5
				enableSceneRedraw()
			)
		--CompleteRedraw()	
	)
	on btn6 pressed do -- box prox
	(
		clearSelection()
	)
	on btn7 pressed do
	(
		local pr = collectAllVProxies selClass:ChaosScatter
		with undo off 
			(
				DisableSceneRedraw()
				hideProxy pr state:true
				enableSceneRedraw()
			)
		--CompleteRedraw()
	)
	on btn8 pressed do
	(
		local pr = collectAllVProxies selClass:ChaosScatter
		with undo off 
			(
				DisableSceneRedraw()
				hideProxy pr state:false
				enableSceneRedraw()
			)
		--CompleteRedraw()
	)
	
	on btn9 pressed do
	(
		 pr = collectAllVProxies selClass:ChaosScatter 
		with undo off 
			(
				DisableSceneRedraw()
				changeSelectionDisplay pr (ddl2.selection)
				enableSceneRedraw()
			)
		--CompleteRedraw()
			
	)
	
)

createdialog displayVMesh