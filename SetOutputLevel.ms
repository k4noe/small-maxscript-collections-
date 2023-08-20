try (DestroyDialog setOUTValueRGB) catch()

rollout setOUTValueRGB "SME Tools" width:162 height:136
(
	spinner 'spn1' "outVal: " pos:[8,10] width:89 height:16 range:[0,10,1] type:#float align:#left
	button 'btn1' "SET" pos:[16,34] width:131 height:19 align:#left
	spinner 'spn2' "Rotate W:" pos:[10,57] width:77 height:16 range:[0,360,0] type:#integer scale:1 align:#left
	button 'btn2' "Apply Rotation" pos:[10,79] width:142 height:21 align:#left
	button 'btn3' "ConvertToVrayBitmap" pos:[12,106] width:139 height:20 align:#left
	
	
	fn getActiveView = 
	(
		sme.getview (sme.activeView)
	)
	
	fn getSlateNode =
	(
		local slate =  undefined 
		slate = (getActiveView()).GetSelectedNodes() 
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
		local nodes = thisSlateNode ints
		local depend= refs.dependents nodes
		local slate =  getActiveView()
		xx = for i in depend where (p = slate.getnodebyref i)!=undefined collect p.reference
		xx --return as array
	)
	
	fn ConvertBitmapToVrayBitmap  = 
	(
		local nodesCol = getSlateNode()	
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
	
	
	fn hasOutputProp node types =
	(
		hasProperty node types
	)
		
	fn convertNodeToVBitmap mats =
	(
		for i=1 to mats.count do 
		(
			local nod= thisSlateNode i
			if (isKindOf nod bitmapTex) and ((inBit = nod.fileName)!="") do 
			(
				local newVBitmap=VRayBitmap name:nod.name HDRIMapName:inBit 
				nod= newVBitmap

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
	
)

CreateDialog setOUTValueRGB
