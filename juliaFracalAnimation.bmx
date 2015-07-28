Strict

Framework BRL.GlMax2D
Import BRL.System
Import BRL.Basic
Import BRL.Retro
Import BRL.Max2D


Graphics 640,480

' Simple Program To Display The Julia Set
Global CX:Double = .344999
Global CY:Double = .074999
Global CCycle:Byte = False
Global in:Byte = False
Global colors:Int[,] = Null
createColors(0)
Global iwidth:Int = 320
Global iheight:Int = 240
Global isize:Int = 3

Cls
While Not KeyHit(KEY_ESCAPE)
	SetBlend(ALPHABLEND)
	SetRotation(0)
	SetColor(0,0,0)
	SetAlpha(.05)
	DrawRect(0,0,800,600)
	SetAlpha(1)
	
	If KeyHit(KEY_1)
		createColors(0)
	ElseIf KeyHit(KEY_2)
		createColors(1)
	ElseIf KeyHit(KEY_3)
		createColors(2)
	EndIf
	
	If KeyHit(KEY_TAB)
		CCycle = Not CCycle
	EndIf
	If KeyHit(KEY_SPACE)
		in = Not in
	EndIf
	
	colorCycle()

	If KeyDown(KEY_RIGHT)
		CX:+.0015
	Else If KeyDown(KEY_LEFT)
		CX:-.0015
	EndIf
	If KeyDown(KEY_DOWN)
		CY:+.0005
	Else If KeyDown(KEY_UP)
		CY:-.0005
	EndIf
	
	If Not in Then
		outJulia(CX,CY,iwidth,iheight,24,isize,-iwidth/2,-iheight/2)
	Else
		inJulia(CX,CY,iwidth/2,iheight/2,24,isize+1)
	EndIf 
	
	
	SetColor(0,0,0)
	DrawText("CX="+CX+" CY="+CY,12,12)
	DrawText("TAB - Toggle Color Cycle",12,27)
	DrawText("SPACE - Toggle IN/OUT Set",12,42)
	DrawText("1,2,3 - Select Color Set",12,57)
	DrawText("UP/DOWN - Change CY",12,72)
	DrawText("LEFT/RIGHT - Change CX",12,87)
	
	SetColor(255,255,255)
	DrawText("CX="+CX+" CY="+CY,10,10)
	DrawText("TAB - Toggle Color Cycle",10,25)
	DrawText("SPACE - Toggle IN/OUT Set",10,40)
	DrawText("1,2,3 - Select Color Set",10,55)
	DrawText("UP/DOWN - Change CY",10,70)
	DrawText("LEFT/RIGHT - Change CX",10,85)
	
	Flip 
Wend

Function colorCycle()
	If CCycle=False Then Return
	Local cc:Int = colors.dimensions()[0]
	Local r:Int = colors[cc-1,0]
	Local g:Int = colors[cc-1,1]
	Local b:Int = colors[cc-1,2]
	For Local i:Int=cc-1 Until 0 Step -1
		colors[i,0]=colors[i-1,0]
		colors[i,1]=colors[i-1,1]
		colors[i,2]=colors[i-1,2]
	Next
	colors[0,0]=r
	colors[0,1]=g
	colors[0,2]=b
End Function

Function createColors(set:Byte)
	Select(set)
	Case 0
	'Rem grey shades
	'------------------------------------
	colors=New Int[256,3]
	For Local ci:Int = 0 Until 256
		colors[ci,0]=ci
		colors[ci,1]=ci
		colors[ci,2]=ci
	Next
	'EndRem
	Case 1
	'Rem darks to lights
	'------------------------------------
	colors=New Int[768,3]
	For Local ci:Int = 0 Until 256
		colors[ci,0]=ci
		colors[ci,1]=0
		colors[ci,2]=0
		colors[ci+256,0]=0
		colors[ci+256,1]=ci
		colors[ci+256,2]=0
		colors[ci+512,0]=0
		colors[ci+512,1]=0
		colors[ci+512,2]=ci
	Next
	'EndRem
	Case 2
	'Rem mid to light to mid
	'------------------------------------
	colors=New Int[768,3]
	For Local ci:Int = 0 Until 128
		colors[ci,0]=ci+128
		colors[ci,1]=0
		colors[ci,2]=0
		colors[ci+256,0]=0
		colors[ci+256,1]=ci+128
		colors[ci+256,2]=0
		colors[ci+512,0]=0
		colors[ci+512,1]=0
		colors[ci+512,2]=ci+128
	Next
	For Local ci:Int = 128 Until 256
		colors[ci,0]=256-ci+128
		colors[ci,1]=0
		colors[ci,2]=0
		colors[ci+256,0]=0
		colors[ci+256,1]=256-ci+128
		colors[ci+256,2]=0
		colors[ci+512,0]=0
		colors[ci+512,1]=0
		colors[ci+512,2]=256-ci+128
	Next
	'EndRem
	End Select
End Function

Function inJulia(CX:Double,CY:Double,WIDTH:Int,HEIGHT:Int,Detail:Int,size:Int,xoff:Int=0,yoff:Int=0)
	SetOrigin(xoff,yoff)
	Local HALF_WIDTH:Double = WIDTH/2
	Local HALF_HEIGHT:Double = HEIGHT/2
	Local QUAR_WIDTH:Double = WIDTH/4
	Local QUAR_HEIGHT:Double = HEIGHT/4
	For Local PixelY:Int = 0 To HEIGHT
		For Local PixelX:Int = 0 To WIDTH
		    	Local ZX:Double = ((PixelX - HALF_WIDTH) / QUAR_WIDTH)
		    	Local ZY:Double = ((PixelY - HALF_HEIGHT) / QUAR_HEIGHT)
		    	For Local i:Int = 0 To Detail
			      	Local NewZX:Double = (ZX * ZX) - (ZY * ZY) + CX
			      	Local NewZY:Double = ((2 * ZX) * ZY) + CY
			      	ZX = NewZX
			      	ZY = NewZY
					Local DISTANCE:Double = (ZX*ZX) + (ZY*ZY)
			      	If DISTANCE > 4 Then 
						DISTANCE=4/DISTANCE * (colors.dimensions()[0]-1)
						SetColor(colors[DISTANCE,0],colors[DISTANCE,1],colors[DISTANCE,2])
						DrawRect((pixelx)*size,(pixely)*size,size,size)
						Exit ' Go to nextpoint
					EndIf
	    		Next
		Next 
	Next
	SetOrigin(0,0)
End Function

Function outJulia(CX:Double,CY:Double,WIDTH:Int,HEIGHT:Int,Detail:Int,size:Int,xoff:Int=0,yoff:Int=0)
	SetOrigin(xoff,yoff)
	Local HALF_WIDTH:Double = WIDTH/2
	Local HALF_HEIGHT:Double = HEIGHT/2
	Local QUAR_WIDTH:Double = WIDTH/4
	Local QUAR_HEIGHT:Double = HEIGHT/4
	For Local PixelY:Int = 0 To HEIGHT
		For Local PixelX:Int = 0 To WIDTH
		    	Local ZX:Double = (PixelX - HALF_WIDTH) / QUAR_WIDTH
		    	Local ZY:Double = (PixelY - HALF_HEIGHT) / QUAR_HEIGHT
				Local DISTANCE:Double = 0 
			    For Local i:Int = 0 To Detail
			      	Local NewZX:Double = (ZX * ZX) - (ZY * ZY) + CX
			      	Local NewZY:Double = ((2 * ZX) * ZY) + CY
			      	ZX = NewZX
			      	ZY = NewZY
					DISTANCE = (ZX*ZX) + (ZY*ZY)
			      	If DISTANCE > 4 Then Exit ' Go to nextpoint
	    		Next
			If DISTANCE<4 Then
				If DISTANCE>1 Then DISTANCE=1
				DISTANCE=DISTANCE * (colors.dimensions()[0]-1)
				SetColor(colors[DISTANCE,0],colors[DISTANCE,1],colors[DISTANCE,2])
				DrawRect(pixelx*size,pixely*size,size,size)
			EndIf
		Next 
	Next
	SetOrigin(0,0)
End Function

