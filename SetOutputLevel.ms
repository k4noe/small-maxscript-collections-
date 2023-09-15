try (DestroyDialog setOUTValueRGB) catch()

rollout setOUTValueRGB "SME Tools" width:162 height:319
(
	
	local presets = #(
	"Alumunium",
	"Alumunium(Rough)",
	"Alumunium(Brushed)",
	"Chrome",
	"Copper",
	"Copper(Rough)",
	"Gold",
	"Gold(Rough)",
	"Iron",
	"Lead",
	"Silver",
	"Silver(Rough)",
	"Diamond",
	"Glass",
	"Glass(Frosted)",
	"Glass(Tinted)",
	"Glass(Architectural)",
	"Water",
	"Chocolate",
	"Ceramic",
	"Plastic",
	"Rubber",
	"RedVelvet",
	"White Satin",
	"Pink Satin",
	"Soap",
	"Buble"
	)
	
	local ms="Replace material with source" 
	
	spinner 'spn1' "outVal: " pos:[8,10] width:89 height:16 range:[0,10,1] type:#float align:#left
	button 'btn1' "SET" pos:[16,34] width:131 height:19 align:#left
	spinner 'spn2' "Bitmap-W-Rotation :" pos:[10,57] width:89 height:16 range:[0,360,0] type:#integer scale:1 align:#left
	button 'btn2' "Apply Rotation" pos:[10,79] width:142 height:21 align:#left
	button 'btn3' "ConvertToVrayBitmap" pos:[12,106] width:139 height:20 align:#left
	
	listbox 'lbx2' "ListBox" pos:[12,132] width:136 height:6 items:presets align:#left
	button 'btn4' "Change V-MatPreset" pos:[12,263] width:137 height:21 align:#left
	checkbox 'chk1' "Add VRayColor" pos:[15,243] width:134 height:16 align:#left
	button 'btn5' "[SME]Replace Mat" pos:[42,286] width:107 height:21 toolTip:ms align:#left
	button 'btn11' "SRC" pos:[12,286] width:28 height:20 align:#left
	
	local sourceMatNode = undefined
	
	fn isOpen = 
	(
		sme.IsOpen() 
	)
	
	fn getActiveView = 
	(
		if (isOpen()) then 
			(
				sme.getview (sme.activeView)
			)
		else 
			(
				sme.Open() 
				sme.getview (sme.activeView)
			)
		
	)
	
	fn getSlateNode =
	(
		local slate = #() 
		slate = (getActiveView()).GetSelectedNodes() 
		if slate==undefined do 
			(
				print "Please select one material node"
				slate =#()
			)
			
		slate 
	)	
	
	fn thisSlateNode ints =
	(
		local nodes = getSlateNode()
		nodes = nodes[ints].reference
		nodes
	)

	fn createVBitmap inText =
	(
		local nodes=VRayBitmap() 
		if (isKindOf inText bitmapTex) do 
		(
			nodes.name=inText.name 
			nodes.HDRIMapName=(inText.filename) 
		)
		nodes
	)		
		
	fn getSMESelectedParent ints = 
	(
		nodes = thisSlateNode ints
		depend= refs.dependents nodes
		slate =  getActiveView()
		xx = for i in depend where (p = slate.getnodebyref i)!=undefined collect p.reference
		xx --return as array
	)
	
	fn ConvertBitmapToVrayBitmap  = 
	(
		nodesCol = getSlateNode()	
		if (nodesCol.count!=0) do 
		(
			for h=1 to nodesCol.count do
			(
				local arr = getSMESelectedParent h --main parent of selected map [ex:#vraymtl and another)
				if arr.count!=0 do 
				(
					local _oldMaps= thisSlateNode h --bitmaptexture from selected
					local _newMap= createVBitmap _oldMaps --create vBitmap from _oldMaps

					for j in arr do 
					(
						local numSub =  getNumSubTexmaps j 
						for i=1 to numSub do 
						(
							if (((p=getSubTexmap j i)==_oldMaps) and (iskindOf p Bitmaptexture)) do 
							(
								setSubTexmap j i _newMap
							)
						)

					)
				)
			)

		)
		OK
	)
	
	fn replaceMaterials sourceNode =
	(
		local _arrMatNode=getSlateNode()
		local fm = format,GA = GetHandleByAnim , SCO = superClassOf, RI = replaceInstances
		clearListener()

		if (_arrMatNode.count>=1 and sourceNode!=undefined) do 
		(
			for i=1 to _arrMatNode.count do 
			(
				local _oldNode  =  thisSlateNode i
				if ((GA _oldNode) == (GA sourceNode)) do continue

				if (SCO _oldNode ==  SCO sourceNode) then  
				(
					RI _oldNode sourceNode transferCAs:true
					fm "Replacing % with % succesfull!\n" _oldNode.name sourceNode.name
				)
				else 
				(
					fm "Source: %'s class did not match with Target: %'s class\n"  sourceNode.name _oldNode.name  
				)
				
			)
		)
		OK
	)	
	
	fn hasOutputProp node types =
	(
		hasProperty node types
	)
	
		
	fn getGetPresetNum input  = 
	(
		input +1
	)
	
	fn createVrayColorMap inColor =
	(
		local vColor =  VRayColor()

		vColor.color = inColor.Diffuse
		vColor
	)
	
	
	--setSubTexmap j i _newMap
	
	fn changeIndividualVMatPreset ints presetNum addVColor:false = 
	(
		 xx = thisSlateNode ints

		if (isKindOf xx VRayMtl) do 
		(

				if (addVColor and xx.texmap_diffuse==undefined) do 
				(
					_newMap = createVrayColorMap xx 
					xx.texmap_diffuse =_newMap
				)
				
				(xx.preset = presetNum)

			)
	)
	
	fn changePresetVMats presetNum addVColor:false = 
	(
		local nodes  =  getSlateNode()
		if nodes.count!= 0 do 
		(
			for i=1 to nodes.count do 
			(
				changeIndividualVMatPreset i presetNum addVColor:addVColor
			)
		)
	)
	
	
	
	fn setBitmapOutputData mats data modOf:1  = 
	(
		for i=1 to mats.count do 
		(
			local mm=(mats[i].reference)
			case modOf of  
			(
				
				(1)	: (if (hasOutputProp mm #output) do
						(
							setProperty (mm.output) #RGB_Level data)
						)
						
				(2)	: (if (hasOutputProp mm #coords) do 
						(
							setProperty (mm.coords) #W_angle data)
						)	
			)
		)
	)
	

	
--=======================================================================
	

	
	
	on btn1 pressed do
	(
		local selSlate =  getSlateNode()
		
		if selSlate.count!=0 do 
		(
			with undo on 
				(
					setBitmapOutputData selSlate (spn1.value) modOf:1
				)
		)
	)
	on btn2 pressed do
	(
		local selSlate =  getSlateNode()
		
		if selSlate.count!=0 do 
		(
			with undo on 
				(
					setBitmapOutputData selSlate (spn2.value) modOf:2
				)
		)
	)
	on btn3 pressed do
	(
		local selSlate =  getSlateNode()
		if ((sme.IsOpen()) and (selSlate.count!=0)) do 
		(
			with undo on (ConvertBitmapToVrayBitmap())
		)
		
	)
	on btn4 pressed do
	(
		local num = getGetPresetNum (lbx2.selection) 
		with undo on  (changePresetVMats num addVColor:(chk1.state))
		
	)
	on btn5 pressed do
	(
		with undo "replace mat" on 
		(
			if sourceMatNode!=undefined do 
			(
				replaceMaterials sourceMatNode	
			)
			
		)
	)
	
	on btn11 pressed do 
	(
		local _nodes  =  getSlateNode()
		if _nodes.count==1 do
		(
			local _matNodes =  thisSlateNode 1 
			if ((superclassof _matNodes == material) or (superclassof _matNodes == textureMap)) do 
			(
				sourceMatNode =  _matNodes
				btn11.tooltip = (sourceMatNode.name as string)
			)
		)
		
	)
	
	on btn11 rightclick do 
	(
		sourceMatNode = undefined
		btn11.tooltip = ""
	)
)

CreateDialog setOUTValueRGB
