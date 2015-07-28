'coded by Zarwan http://www.dbfinteractive.com/forum/index.php?action=profile;u=37

Graphics 800,600,32,0
SeedRnd MilliSecs()

lineAngle1 = Rnd( 359 )
lineAngle2 = Rnd( 359 )
lineAngle3 = Rnd( 359 )
lineAngle4 = Rnd( 359 )
lineAngle1add = Rnd( 1, 3 )
lineAngle2add = Rnd( 1, 3 )
lineAngle3add = Rnd( 1, 3 )
lineAngle4add = Rnd( 1, 3 )
lineColor1 = 255
lineColor2 = 255
lineColor3 = 255
numberOfLines = 128
lineSpace = 2
angleChangeRate = 15
angleUpdateRate = 250
colorUpdateRate = 5000

While Not KeyHit(key_escape)
	Cls
	
	
	angle1tmp = lineAngle1	' copy current angles
	angle2tmp = lineAngle2
	angle3tmp = lineAngle3
	angle4tmp = lineAngle4
	
	SetColor lineColor1, lineColor2, lineColor3

	For i = 1 To numberOfLines
		' find the two End points
		x1 = 320 + Sin( angle1tmp ) * 199
		x2 = 320 + Sin( angle2tmp ) * 199
		y1 = 240 + Sin( angle3tmp ) * 199
		y2 = 240 + Sin( angle4tmp ) * 199
		' draw the line
		DrawLine x1, y1, x2, y2
		' add the Step in angle
		angle1tmp = angle1tmp + lineSpace
		angle2tmp = angle2tmp + lineSpace
		angle3tmp = angle3tmp + lineSpace
		angle4tmp = angle4tmp + lineSpace
	Next
	
	' check If its time To advance the angles
	If (MilliSecs() > lastAngleChange + angleChangeRate)
		lastAngleChange = MilliSecs()
		lineAngle1 = lineAngle1 + lineAngle1add ; If lineAngle1 > 359 Then lineAngle1 = lineAngle1 - 360
		lineAngle2 = lineAngle2 + lineAngle2add ; If lineAngle2 > 359 Then lineAngle2 = lineAngle2 - 360
		lineAngle3 = lineAngle3 + lineAngle3add ; If lineAngle3 > 359 Then lineAngle3 = lineAngle3 - 360
		lineAngle4 = lineAngle4 + lineAngle4add ; If lineAngle4 > 359 Then lineAngle4 = lineAngle4 - 360
	End If
	
	
	If MilliSecs() > lastAngleUpdate + angleUpdateRate 	' check If its time To change the angle add values
		lastAngleUpdate = MilliSecs()
		r = Rnd( 3 )
		If r = 0 Then lineAngle1add = Rnd( 1, 4 )
		If r = 1 Then lineAngle2add = Rnd( 1, 4 )
		If r = 2 Then lineAngle3add = Rnd( 1, 4 )
		If r = 3 Then lineAngle4add = Rnd( 1, 4 )
	End If	
	
	If MilliSecs() > lastColorUpdate + colorUpdateRate 	' check If its time To change the color
		lastColorUpdate = MilliSecs()
		lineColor1 = Rnd( 50, 255 )
		lineColor2 = Rnd( 50, 255 )
		lineColor3 = Rnd( 50, 255 )
	End If
	
	Flip	
Wend
End
