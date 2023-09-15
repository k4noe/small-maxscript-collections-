try (destroyDialog distanceMod) catch()
rollout distanceMod "Distance" width:218 height:160
(
	listBox 'lbx1' "Measure History" pos:[6,7] width:200 height:7 align:#left
	button 'btn1' "Measure" pos:[6,130] width:100 height:25 align:#left
	button 'btn2' "Clear" pos:[108,130] width:100 height:25 align:#left
	
	local snapList= #(5,10,1,2,2,2,6)
	
	fn setSnapMode name: state: =
	(
		case name of
		(
			"Grid Points": snapmode.setOSnapItemActive 4 1 state
			"Grid Lines": snapmode.setOSnapItemActive 4 2 state
			"Pivot": snapmode.setOSnapItemActive 5 1 state
			"Bounding Box": snapmode.setOSnapItemActive 5 2 state
			"Perpendicular": snapmode.setOSnapItemActive 6 1 state
			"Tangent": snapmode.setOSnapItemActive 6 2 state
			"Vertex": snapmode.setOSnapItemActive 7 1 state
			"Endpoint": snapmode.setOSnapItemActive 7 2 state
			"Edge/Segment": snapmode.setOSnapItemActive 7 3 state
			"Midpoint": snapmode.setOSnapItemActive 7 4 state
			"Face": snapmode.setOSnapItemActive 7 5 state
			"Center Face": snapmode.setOSnapItemActive 7 6 state
		)
		max drawingaids; max drawingaids
	)
	
	fn saveSnapDict list:#() = 
	(
		local activeSnapList =#()
		
		for i=1 to list.count do 
		(
			_snapIdx =  list[i]
			for j=1 to _snapIdx do 
			(
				if (snapMode.getOSnapItemActive i j) do 
				(
					append activeSnapList #(i,j)
				)
			)
		)
		activeSnapList
	)
	
	fn disableAllSnapDict state:false list:#() = 
	(
		--local snapList =  #(5,10,1,2,2,2,6)
		
		for i=1 to list.count do --2
		(
			_snapIdx =  list[i] --10
			for j=1 to _snapIdx do 
			(
				snapmode.setOSnapItemActive i j state
			)
		)
	)		

	fn activateSnapFromDict state:true dictArr:#()=
	(
		-- ex: arr =#(#(2, 1), #(2, 2), #(2, 1), #(2, 2), #(6, 1), #(6, 4))
		for i=1 to dictArr.count do 
		(
			snapmode.setOSnapItemActive dictArr[i][1] dictArr[i][2] state
		)
	)
		
	fn startMeasure =
	(
		clearListener()
		local dist=0,p1,p2
		local prevSnapState = snapMode.active -- save previouse snap state
		local previousActiveSnap = (saveSnapDict list:snapList) --save activesnap
		-- format "previous snap :%\n" previousActiveSnap
		-- start measuring 
		if (not prevSnapState) do (snapMode.active=true)
		
		disableAllSnapDict state:false list:snapList --disable all snap 
		setSnapMode name:"Vertex" state:true  --activate vertex 
		
		p1 = pickPoint snap:#3d 
		p2 = pickPoint snap:#3d rubberBand:p1
		dist = distance p1 p2
		
		setSnapMode name:"Vertex" state:false --deactivate vertex
		-- restoring all snap 
		snapMode.active=prevSnapState
		activateSnapFromDict state:true dictArr:previousActiveSnap 
		dist
	)
		
	on btn1 pressed do
	(
		local arr = lbx1.items 
		local res = append arr (startMeasure() as string)
		lbx1.items = arr
	)
	
	on btn2 pressed do 
	(
		lbx1.items= #()
	)
	
	on lbx1 doubleClicked itm do 
	(
		if ((p=lbx1.selected) !=undefined ) do
		(
			setclipboardText p
		)
		
	)
	
)

createDialog distanceMod
