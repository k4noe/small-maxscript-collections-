clearListener() 

try (DestroyDialog ApplyRadomColorByMat) catch()

rollout ApplyRadomColorByMat "WireColor Tools" width:250 height:290
(
	fn filterGeo node =
	(
		superclassof node== GeometryClass or \
		superclassof node== shape 
	)
	
	listbox 'lbx1' "ListBox" pos:[5,8] width:239 height:10 align:#left
	colorPicker 'cp1' "ColorPicker" pos:[98,175] width:146 height:21 align:#left
	button 'btn2' "Random All" pos:[4,201] width:242 height:24 align:#left
	pickbutton 'pBtn10' "PickObj" pos:[8,177] width:82 height:17 filter:filterGeo autoDisplay:true align:#left
	
	button 'btn3' "Make Box UVW" pos:[126,227] width:95 height:24 align:#left
	button 'btn4' "Apply Box UVW" pos:[5,227] width:95 height:24 align:#left
	checkbutton 'ckb1' "Always in Base" pos:[4,253] width:242 height:24 align:#left
	
	checkButton 'ckb3' "I" pos:[101,227] width:24 height:24 toolTip:"Instanced Mod or Not" align:#left
	checkbutton 'btn10' "P" pos:[222,227] width:24 height:24 toolTip:"UVW::Map multiplier preset" align:#left

	
	
	fn notScatter node =
	(
		not (isKindOf node ChaosScatter)
	)

	fn inFace node = 
	(
		local modes =  modpanel.getCurrentObject()
		
		(isKindOf modes Editable_Poly and (subobjectLevel==4 or subobjectLevel==5)) or \
		(isKindOf modes Edit_Poly and (subobjectLevel==4 or subobjectLevel==5))or \
		(isKindOf modes Editable_Mesh and (subobjectLevel==4 or subobjectLevel==5)) or \
		(isKindOf modes Edit_Mesh and (subobjectLevel==4 or subobjectLevel==5)) or \
		
		(isKindOf modes Poly_Select and (subobjectLevel==4 or subobjectLevel==5)) or \ 
		(isKindOf modes Mesh_Select and (subobjectLevel==4 or subobjectLevel==5))
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
	
	fn alwaysInBaseMode node =
	(
		if selection.count==1 do 
		(
			modPanel.setCurrentObject node.baseObject
		)
	)
	
	mapped fn getInstanceHead nodes &inst=  
	(
		
		InstanceMgr.GetInstances nodes &firstOnly
		appendIfUnique inst firstOnly[1]
	)
	
	fn setUVWBox node scaleUp: rotateAngel: axis:"Z" =
	(
		if selection.count==1 do 
		(
			local currentMod = modpanel.getCurrentObject()
			if isKindOf currentMod Uvwmap do 
			(
				local normalVal =  [1,1,1]
				local normalRot =  (quat 0 0 -1 0) as eulerAngles
				
				
				local a=currentMod.length, b=currentMod.width, c = currentMod.height 
				local arrVal = amin #(a,b,c)
				currentMod.length = currentMod.width = currentMod.height = arrVal
				
				if scaleUp !=unsupplied do 
				(
					currentMod.gizmo.scale=normalVal*scaleUp
					
				)

				if rotateAngel!=unsupplied do
				(
					case axis of 
					(
						"X" :(currentMod.gizmo.rotation = (eulerAngles rotateAngel 0 0))
						"Y"	:(currentMod.gizmo.rotation = (eulerAngles 0 rotateAngel 0))
						"Z"	: (currentMod.gizmo.rotation = (eulerAngles 0 0 rotateAngel))
					)
					
				)
				
			)
		)
	)
	
	fn applyUVWMap nodes instancedMod:false  =
	(
		
		local _nodeArr =#(),adMod= addModifier,cp=copy
		getInstanceHead nodes &_nodeArr
		if _nodeArr.count!=0 do 
		(
			local _sz = 1000
			local instancedUVWMod = Uvwmap length:_sz width:_sz height:_sz maptype:4 scale:[1,1,1]

			case of 
			(
				((_nodeArr.count==1) and (inFace _nodeArr[1])) : 
									(
										modPanel.addModToSelection (instancedUVWMod)
									)									
				default :	(
							for i in _nodeArr do 
								(
									local modes = (cp instancedUVWMod)
									if instancedMod then 
										(
											adMod i instancedUVWMod
										)
									else 
										(
											adMod i modes
										)
									 
								)
							)
			)
			

			OK
		)
	)
	
	fn createDialogUVWMultipler = 
	(
		rollout UVWMultiplyPreset "UVWMap::Tools" width:150 height:155
		(
			
			local lbxItems= #("x0.4","x0.5","x0.6","x0.75","x1","x2","x3","x4","x5","x6","x8", "x10","x15", "x25","x50", "x100","x200", "x500","x1000")
			local rotItems= #("5","15","30","45", "60","75", "90","105", "120", "135","150","165", "180")
			local axisz=#("X", "Y", "Z")
			
			
			listbox 'lbx3' "Mult:List" pos:[3,4] width:70 height:7 items:lbxItems align:#left
			checkbox 'chk1' "AutoClose" pos:[3,127] width:69 height:16 align:#left
			listBox 'lbx6' "Rot::List" pos:[78,4] width:70 height:7 items:rotItems align:#left
			dropDownList 'ddl1' "" pos:[97,128] width:46 height:22 items:axisz align:#left selection:3
			
			
			on lbx3 doubleClicked idx do 
			(
				--print idx
				local mult =  execute ((filterString (lbx3.selected) "x")[1])
				print mult 
				
				with undo on (setUVWBox node scaleUp:mult)
				if chk1.state do (try (DestroyDialog UVWMultiplyPreset) catch())
			)
			
			
			on lbx6 doubleClicked idx do
			(
				local mult =  execute (lbx6.selected) 
				local rot =  (eulerAngles 0 0 mult)
				
				with undo on (setUVWBox node rotateAngel:mult axis:(ddl1.selected))
				if chk1.state do (try (DestroyDialog UVWMultiplyPreset) catch())
			)
			
			on UVWMultiplyPreset close do 
			(
				if (ApplyRadomColorByMat.btn10.state) do ( ApplyRadomColorByMat.btn10.checked = false)
				
			)
			
		)
	)
	
	--==============================
	local namedMat=undefined
	local zz = collectMaterialName()
	--==============================

	
	on ApplyRadomColorByMat open do
	(
		yy = for i in zz collect i[2]  
		lbx1.items= yy
	)
	
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
	on pBtn10 picked obj do
	(
		local lbxName = ApplyRadomColorByMat.lbx1.items
		namedMat = obj.material.name
		idx  = findItem lbxName namedMat 
		lbx1.selection =idx
		
	)
	on btn3 pressed do
	(
		setUVWBox selection[1]
	)
	on btn4 pressed do
	(
		applyUVWMap (selection as array) instancedMod:(ckb3.state)
	)
	
	on btn10 changed state do 
	(
		local dia =  createDialogUVWMultipler()
		if state then 
		(
			local mainDiaPos =  GetDialogPos ApplyRadomColorByMat
			local mainDiaSize = GetDialogSize ApplyRadomColorByMat
			
			try (DestroyDialog UVWMultiplyPreset) catch()
			CreateDialog dia parent:(ApplyRadomColorByMat.hwnd)
			SetDialogPos dia [(mainDiaPos.x+mainDiaSize.x+5),mainDiaPos.y]
		)
		else 
		(
			try (DestroyDialog UVWMultiplyPreset) catch()
		)
		
		
	)
	
	on ApplyRadomColorByMat moved pt do 
	(
		local mainDiaPos =  GetDialogPos ApplyRadomColorByMat
		local mainDiaSize = GetDialogSize ApplyRadomColorByMat
		
		local ptz =  GetDialogSize UVWMultiplyPreset
		if ptz!=[0,0] do 
		(
			SetDialogPos UVWMultiplyPreset [(mainDiaPos.x+mainDiaSize.x+5),mainDiaPos.y]
		)
	)
	
	
)
CreateDialog ApplyRadomColorByMat
	