Const xres=1024
'code by TinDragon
'http://www.dbfinteractive.com/forum/index.php?topic=4024.0

Const yres=768

Graphics xres,yres,0


Global numpoints			' Number of points in the point table.
Global numconn				' Number of connections in the connect table.
Global distance  = 250		' Used to calculate perspective.
Global rotx#				' X rotation.
Global roty#				' Y rotation.
Global rotz#				' Z rotation.
Global angle#=0.5			' Rotation angle speed
Global centrex=xres/2		' Centre offset x
Global centrey=yres/2		' Centre offset	y
Global numstars=300			' Number of stars in 3d field

' Read data for 3d.
ReadData numpoints			' Read in the number of points in the object
Global points[numpoints+1, 3]	' Holds the point locations of the  3d object.
Global xpos[numpoints+1]
Global ypos[numpoints+1]
For n = 1 To numpoints
	ReadData x, y, z
	points(n, 0) = x
	points(n, 1) = y
	points(n, 2) = z
Next
ReadData numconn			' Read in the numer of connections in the 3d object
Global lines[numconn+1, 2]	' Holds the connections of the 3d a to b.
For n = 1 To numconn
	ReadData a, b
	lines(n, 0) = a
	lines(n, 1) = b
Next 

' Data for starfield
Global starx[numstars+1]
Global	stary[numstars+1]
Global starz[numstars+1]
Global speed[numstars+1]
For lop=0 To numstars
	starx(lop)=Rnd(-149,149)
	stary(lop)=Rnd(-74,74)
	starz(lop)=Rnd(-49,49)
	speed(lop)=1+(lop Mod 3)
Next

' ------------------ Main Loop
Repeat
	Cls
	box3d()
	star3d()
	Flip 
	' Update rotation angles
	rotx# =(rotx# + angle#) Mod 360
	roty# =(roty# + angle#) Mod 360
	rotz# =(rotz# + angle#) Mod 360
Until KeyDown(KEY_ESCAPE) Or MouseDown(1)
End
' ------------------ End main loop

' --- This rotates and draws the box
Function box3d()
	SetColor 0,255,255
	For n = 1 To numpoints
		x = points(n, 0)
		y = points(n, 1)
		z = points(n, 2)
       	' X rotation
		ty# = ((y * Cos(rotx#)) - (z * Sin(rotx#)))
		tz# = ((y * Sin(rotx#)) + (z * Cos(rotx#)))
		' Y rotation
		tx# = ((x * Cos(roty#)) - (tz# * Sin(roty#)))
		tz# = ((x * Sin(roty#)) + (tz# * Cos(roty#)))
		' Z rotation
		ox# = tx#
		tx# = ((tx# * Cos(rotz#)) - (ty# * Sin(rotz#)))
		ty# = ((ox# * Sin(rotz#)) + (ty# * Cos(rotz#)))
		' Calculate new x and y location with perspective
		'xpos(n)=(tx#*(distance/(distance+tz#)))+centrex
		'ypos(n)=(ty#*(distance/(distance+tz#)))+centrey
		xpos(n)=(tx#*(400/(distance+tz#)))+centrex
		ypos(n)=(ty#*(400/(distance+tz#)))+centrey
	Next
	For n = 1 To numconn
		DrawLine xpos(lines(n, 0)), ypos(lines(n, 0)),xpos(lines(n, 1)), ypos(lines(n, 1))
	Next
End Function

' --- This rotates and draws the 3d starfield
Function star3d()
	For n = 0 To numstars
		x = starx(n)
		y = stary(n)
		z = starz(n)
       	' X rotation
		ty# = ((y * Cos(rotx#)) - (z * Sin(rotx#)))
		tz# = ((y * Sin(rotx#)) + (z * Cos(rotx#)))
		' Y rotation
		tx# = ((x * Cos(roty#)) - (tz# * Sin(roty#)))
		tz# = ((x * Sin(roty#)) + (tz# * Cos(roty#)))
		' Z rotation
		ox# = tx#
		tx# = ((tx# * Cos(rotz#)) - (ty# * Sin(rotz#)))
		ty# = ((ox# * Sin(rotz#)) + (ty# * Cos(rotz#)))
		' Calculate new x and y location with perspective
		nx=(tx#*(400/(distance+tz#)))+centrex
		ny=(ty#*(400/(distance+tz#)))+centrey
		If speed(n)<2
			SetColor 100,100,100
		EndIf
		If speed(n)=2
			SetColor 175,175,175
		EndIf
		If speed(n)>2
			SetColor 255,255,255
		EndIf
		If nx>0 And nx<xres
			If ny>0 And ny<yres
				Plot nx,ny
			EndIf
		EndIf
		starx(n)=starx(n)+speed(n)
		If starx(n)>149
			starx(n)=-149
		EndIf
	Next
End Function

' Define a cube
DefData 8 ' Points in cube
DefData -150,-75,50
DefData 150,-75,50
DefData 150,-75,-50
DefData -150,-75,-50
DefData -150,75,50
DefData 150,75,50
DefData 150,75,-50
DefData -150,75,-50
DefData 12 ' Number of connecting lines
DefData 1,2
DefData 2,3 
DefData 3,4
DefData 4,1
DefData 5,6
DefData 6,7
DefData 7,8
DefData 8,5
DefData 8,4
DefData 7,3
DefData 6,2
DefData 5,1 
