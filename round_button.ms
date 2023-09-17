try(destroydialog wpfRollout) catch()
clearListener()
rollout wpfRollout "" width:147 height:232
(
	local topPos = #([8,40],[24,24],[40,8],[49,40],[65,24],[81,8],[88,40],[104,24],[120,8])
	local middlePos =  #([8,104],[24,88],[40,72],[49,104],[65,88],[81,72],[88,104],[104,88],[120,72])
	local bottomPos = #([8,167],[24,151],[40,135],[49,167],[65,151],[81,135],[88,167],[104,151],[120,135])
	
	
	dotNetControl top1 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top2 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top3 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top4 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top5 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top6 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top7 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top8 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top9 "Integration.ElementHost" width:10 height:10 align:#left
	
	dotNetControl top10 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top11 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top12 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top13 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top14 "Integration.ElementHost" width:14 height:14 align:#left 
	dotNetControl top15 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top16 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top17 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top18 "Integration.ElementHost" width:10 height:10 align:#left
	
	
	dotNetControl top19 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top20 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top21 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top22 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top23 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top24 "Integration.ElementHost" width:10 height:10 align:#left

	dotNetControl top25 "Integration.ElementHost" width:10 height:10 align:#left
	dotNetControl top26 "Integration.ElementHost" width:10 height:10 align:#left 
	dotNetControl top27 "Integration.ElementHost" width:10 height:10 align:#left
	
	
	
	mapped fn putPivot obj inputNum= 
	(
		local minmax =  #(obj.max,obj.min)
		/*
		case inputNum of 
		(
			1  : ( obj.pivot = [minmax[2].x, minmax[2].y, minmax[1].z])
			2  : ( obj.pivot = [minmax[2].x, minmax[2].y, (minmax[1].z+minmax[2].z)/2])
			3  : ( obj.pivot = [minmax[2].x, minmax[2].y, minmax[2].z])
			4  : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[2].y, minmax[1].z])
			5  : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[2].y, (minmax[1].z+minmax[2].z)/2])
			6  : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[2].y, minmax[2].z])
			7  : ( obj.pivot = [minmax[1].x, minmax[2].y, minmax[1].z])
			8  : ( obj.pivot = [minmax[1].x, minmax[2].y, (minmax[1].z+minmax[2].z)/2])
			9  : ( obj.pivot = [minmax[1].x, minmax[2].y, minmax[2].z)
		
			10 : ( obj.pivot = [minmax[2].x, (minmax[1].y+minmax[2].y)/2, minmax[1].z])
			11 : ( obj.pivot = [minmax[2].x, (minmax[1].y+minmax[2].y)/2, (minmax[1].z+minmax[2].z)/2])
			12 : ( obj.pivot = [minmax[2].x, (minmax[1].y+minmax[2].y)/2, minmax[2].z])
			13 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, (minmax[1].y+minmax[2].y)/2, minmax[1].z)
		
			14 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, (minmax[1].y+minmax[2].y)/2, (minmax[1].z+minmax[2].z)/2) -- center
		
			15 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, (minmax[1].y+minmax[2].y)/2, minmax[2].z])
			16 : ( obj.pivot = [minmax[1].x, (minmax[1].y+minmax[2].y)/2, minmax[1].z])
			17 : ( obj.pivot = [minmax[1].x, (minmax[1].y+minmax[2].y)/2, (minmax[1].z+minmax[2].z)/2])
			18 : ( obj.pivot = [minmax[1].x, (minmax[1].y+minmax[2].y)/2, minmax[2].z)
			
			19 : ( obj.pivot = [minmax[2].x, minmax[1].y, minmax[1].z])
			20 : ( obj.pivot = [minmax[2].x, minmax[1].y, (minmax[1].z+minmax[2].z)/2])
			21 : ( obj.pivot = [minmax[2].x, minmax[1].y, minmax[2].z])
			22 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[1].y, minmax[1].z])
			23 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[1].y, (minmax[1].z+minmax[2].z)/2])
			24 : ( obj.pivot = [(minmax[1].x+minmax[2].x)/2, minmax[1].y, minmax[2].z])
			25 : ( obj.pivot = [minmax[1].x, minmax[1].y, minmax[1].z])
			26 : ( obj.pivot = [minmax[1].x, minmax[1].y, (minmax[1].z+minmax[2].z)/2])
			27 : ( obj.pivot = [minmax[1].x, minmax[1].y, minmax[2].z])
		)*/
		
	)
	
	fn solidBrush r g b =  (dotnetobject "System.Windows.Media.SolidColorBrush" ((dotnetclass "System.Windows.Media.Color").FromArgb 255 r g b))
	fn mcolor r g b = ((dotnetclass "System.drawing.color").FromArgb 255 r g b)
	
	local redColor = (solidBrush 255 0 0)
	local greenColor = (solidBrush 0 255 0)
	local blueColor =(solidBrush 0 0 255)
	local yellowColor = (solidBrush 255 255 0)
	
	fn maxBackColor = 
	(
		local maxBackColor = colorMan.getColor #background
		local dotNetBackColor = mcolor (maxBackColor[1] * 255.0f) (maxBackColor[2] * 255.0f) (maxBackColor[3] * 255.0f)
		dotNetBackColor
	)
	
	fn colors= 
		(
		local  mcolor = dotnetclass "System.Windows.Media.Brush" 
		--showProperties mcolor
		local dotNetColor =  mcolor.fromArgb (255 255 0 0)-- from argb
		dotNetColor	
	)
	
	fn makeLine tebal:1.5f firstPoint:[1,1] secondPoint:[50,50] =
	(
		myLine = dotnetobject "System.Windows.Shapes.Line"
		myLine.Stroke = dotnetobject "System.Windows.Media.SolidColorBrush" (mcolor.FromArgb 255 0 0 0)
		
		myLine.X1 = firstPoint.x
		myLine.Y1 = firstPoint.y
		
		myLine.X2 = secondPoint.x
		myLine.Y2 = secondPoint.y
		myLine.HorizontalAlignment = HorizontalAlignment.Left
		myLine.VerticalAlignment = VerticalAlignment.Center
		myLine.StrokeThickness = tebal
	)
	
	
	fn makeToolBall size:[8,8] tags:undefined fillColor:redColor =
	(
		local ball = dotnetobject "System.Windows.Shapes.Ellipse"
		local mcolor = dotnetclass "System.Windows.Media.Color"
		
		ball.Width = size.x
		ball.Height = size.y
		ball.Stroke = solidBrush 5 5 5 --Black --MidnightBlue
		ball.StrokeThickness = 0.0f

		ball.Fill = fillColor --dotnetobject "System.Windows.Media.SolidColorBrush" (fillColor) --this is the fill color
		ball.tag = tags

		
		fn onMouseDown s e = (format "%\n" s.tag)
		
		dotnet.addeventhandler ball "MouseDown" onMouseDown
		
		fn onMouseUp s e = (format "\n" )
		
		dotnet.addeventhandler ball "MouseUp" onMouseUp
		
		ball
	)	

	on wpfRollout open do
	(
		type = dotNetClass "System.Int32"
		
		-- top thing 
		for i=1 to 9 do
		(
			local netVal  =  dotnet.ValueToDotNetObject i type
			local val = (dotNetMXSValue i)
			wpfRollout.controls[i].pos = topPos[i] 
			wpfRollout.controls[i].child = makeToolBall tags:val fillColor:redColor
			wpfRollout.controls[i].Backcolor=maxBackColor()
		)
		
		-- center thing
		for i=1 to 9 do 
		(
			local _newVal  =  i+9
			local netVal  =  dotnet.ValueToDotNetObject _newVal type
			local val = (dotNetMXSValue _newVal)
			wpfRollout.controls[_newVal].pos = middlePos[i] 
			if _newVal == 14 then 
				(
					wpfRollout.controls[_newVal].child = makeToolBall tags:val fillColor:yellowColor
				)
				else 
				(
					wpfRollout.controls[_newVal].child = makeToolBall tags:val fillColor:greenColor
				)
			
			
			wpfRollout.controls[_newVal].Backcolor=maxBackColor()
			
		)
		
		-- bottom thing
		
		for i=1 to 9 do 
		(
			local _newVal  =  i+18
			local netVal  =  dotnet.ValueToDotNetObject _newVal type
			local val = (dotNetMXSValue _newVal)
			
			wpfRollout.controls[_newVal].pos = bottomPos[i] 
			wpfRollout.controls[_newVal].child = makeToolBall tags:val fillColor:blueColor
			wpfRollout.controls[_newVal].Backcolor=maxBackColor()
			
		)
	)
)

createDialog wpfRollout style:#(#style_toolwindow,#style_sysmenu,#style_resizing)
--https://forums.cgsociety.org/t/dot-net-buttons/1577205
-- https://forums.cgsociety.org/t/net-wpf-and-maxscript-coding-exploration/1588755