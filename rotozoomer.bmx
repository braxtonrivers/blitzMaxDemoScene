'=================================================================
' By: Scott Shaver
'
' This is based HEAVILY on code from Rbraz at the Dark Bit Factory
' forums. The original version was in PlitzPlus.
'=================================================================
Strict 

Framework BRL.GlMax2D
Import BRL.System
Import BRL.Basic
Import BRL.Retro
Import BRL.Max2D
Import BRL.pngloader

Graphics 320,240',32',60

'=================================================================
SetMaskColor(0,0,0)
Incbin "images/c64.png"
Global logo:TImage = LoadImage("incbin::images/c64.png")
Global pixmap:TPixmap = LockImage(logo)

Incbin "images/island.png"
Global bg:TImage = LoadImage("incbin::images/island.png")


Global ang:Double=0
'=================================================================
While Not KeyHit(KEY_ESCAPE)
	Cls
	
	' draw the background
	SetAlpha(1)
	SetColor(255,255,255)
	TileImage(bg,0,0)
	
	' do the rotation and zoom
	DoIt(pixmap,ang)
	
	' increase the angle each frame
	ang:+1
	Flip
Wend
UnlockImage(logo)
End

' this is the rotozoom function
Function DoIt(pixmap:TPixmap,angle:Float)

	Local osin:Double = Sin(angle)
	Local sina:Float = (osin*1.5)*(osin*1.5)
	Local cosa:Float = (Cos(angle)*1.5)*(osin*1.5)
	Local w:Int = GraphicsWidth()
	Local h:Int = GraphicsHeight()
	Local iw:Int = pixmap.width'ImageWidth(image)
	Local ih:Int = pixmap.height'ImageHeight(image)
	Local iwh:Int = iw Shr 1
	Local ihh:Int = ih Shr 1
	
	' fill in the entire screen area
	For Local x:Int = 0 Until w
		For Local y:Int = 0 Until h
		
			' find out which image pixel to read from
			Local rx:Double = Abs((x * cosa - y * sina) + iwh) Mod iw
			Local ry:Double = Abs((x * sina + y * cosa) + ihh) Mod ih
			
			Local pixel:Int = pixmap.ReadPixel(rx,ry)
			Local a:Float = (pixel & $FF000000) Shr 24
			If a>0 Then
				Local r:Float = (pixel & $00FF0000) Shr 16
				Local g:Float = (pixel & $0000FF00) Shr 8
				Local b:Float = (pixel & $000000FF)
				SetAlpha(a/255)
				SetColor(r,g,b)
				Plot x,y
			EndIf
		Next
	Next
End Function
