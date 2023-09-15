clearListener() 

try (DestroyDialog ApplyRadomColorByMat) catch()

rollout ApplyRadomColorByMat "WireColor Tools" width:250 height:232
(
	fn filterGeo node =
	(
		superclassof node== GeometryClass or \
		superclassof node== shape 
	)
	
	listbox 'lbx1' "ListBox" pos:[5,8] width:239 height:10 align:#left
	colorPicker 'cp1' "ColorPicker" pos:[98,175] width:146 height:21 align:#left
	button 'btn2' "Random All" pos:[4,201] width:242 height:24 align:#left
	pickButton 'pBtn10' "PickObj" pos:[8,177] width:82 height:17 align:#left filter:filterGeo autoDisplay:true
	
	


	fn notScatter node =
	(
		not (isKindOf node ChaosScatter)
	)

	fn collectMaterial = 
	(
		xx = #()
		for i in objects where (i.mat !=undefined ) do appendIfUnique xx i.material 
		xx
	)

	fn collectMaterialName =
	(
		named =  #()
		local  xx = collectMaterial()
		for i in xx do append named #(i,i.name)  
		named
	)

	mapped fn applyColToNode sel =			
	(
		
		local xx = refs.dependents sel  
		local col =  random white black
		for b in xx where ((filterGeo b) and (notScatter b)) do 
		(
			b.wirecolor=col
		)
	)
	
	--==============================
	local namedMat=undefined
	local zz = collectMaterialName()
	--==============================

	on cp1 changed col do 
	(
		if namedMat!=undefined do 
		(
			for i in zz where (stricmp i[2] namedMat == 0 ) do 
			(
				re =  refs.dependents i[1]
				for b in re where ((filterGeo b) and (notScatter b)) do
				(
					b.wirecolor = col 
				)
				
			)
		)
		
	)
	
	on pBtn10 picked obj do
	(
		local lbxName = ApplyRadomColorByMat.lbx1.items
		namedMat = obj.material.name
		idx  = findItem lbxName namedMat 
		lbx1.selection =idx
		
	)
	
	on ApplyRadomColorByMat open do
	(
		yy = for i in zz collect i[2]  
		lbx1.items= yy
	)
	
	
	on btn2 pressed do
	(
		DisableSceneRedraw()
		with undo off 
		(
			xx =  collectMaterial()
			applyColToNode xx 
		)
		enableSceneRedraw()
	)
	
	
	
	
)
CreateDialog ApplyRadomColorByMat
	