Strict 

Framework BRL.GlMax2D
Import BRL.System
Import BRL.Basic
Import BRL.Retro
Import BRL.Max2D
Graphics 640,480,32',60

Global scaleX:Float = 4
Global scaleY:Float = 4
Global angle:Float = 0
Global angleOff:Float = 4
Global plasma:Int = 1
Global factor:Float = 2

While Not KeyHit(KEY_ESCAPE)
	Delay 20/scaleX
	Cls
	
	' space changes the effect
	If KeyHit(KEY_SPACE)
		plasma:+1
		If plasma>7 Then plasma=1
		Select plasma
			Case 1
				factor=2
				Plasma1(factor)
			Case 2
				factor=2
				Plasma2(factor)
			Case 3
				angle=0
				factor=1
				Plasma3(factor)
			Case 4
				angle=0
				factor=1
				Plasma4(factor)
			Case 5
				factor=2
				Plasma5(factor)
			Case 6
				factor=2
				Plasma6(factor)
			Case 7
				factor=2
				Plasma7(factor)
		End Select
	End If
	
	' up arrow increases scale
	If KeyHit(KEY_UP)
		scaleX:+1
		scaleY:+1
	' down arrow decreases scale
	Else If KeyHit(KEY_DOWN) And scaleX>1
		scaleX:-1
		scaleY:-1
	End If
	
	' right arrow increases factor
	If KeyDown(KEY_RIGHT)
		factor:+.01
	' left arrow decreases factor
	Else If KeyDown(KEY_LEFT) And scaleX>1
		factor:-.01
	End If
	
	Select plasma
		Case 1
			Plasma1(factor)
		Case 2
			Plasma2(factor)
		Case 3
			Plasma3(factor)
		Case 4
			Plasma4(factor)
		Case 5
			Plasma5(factor)
		Case 6
			Plasma6(factor)
		Case 7
			Plasma7(factor)
	End Select
	DrawStats()
	
	Flip
	angle:+angleOff
Wend
End

Function DrawStats()
	SetScale(1,1)
	SetColor(0,0,0)
	DrawText("     Plasma (Space): "+plasma,10,10)
	DrawText("   Scale (Up/Down) : "+scaleX,10,25)
	DrawText("Factor (Left/Right): "+factor,10,40)
	SetColor(255,255,255)
	DrawText("     Plasma (Space): "+plasma,9,9)
	DrawText("   Scale (Up/Down) : "+scaleX,9,24)
	DrawText("Factor (Left/Right): "+factor,9,39)
End Function

Function Plasma1(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			' nice pulsing
			Local sxf:Float = Sin(x*scaleX*factor)
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local rindex:Int = Abs(256*( sxf + syf + Sin(angle) ))
			Local gindex:Int = Abs(256*( cyf + sxf + Cos(angle) ))
			Local bindex:Int = Abs(256*( cyf + sxf ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma2(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			' cool
			Local sxf:Float = Sin(x*scaleX*factor)
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local cxf:Float = Cos(x*scaleX*factor)
			Local sa:Float = Sin(angle)
			Local ca:Float = Cos(angle)
			Local rindex:Int = Abs(256*( sxf + cyf + sa ))
			Local gindex:Int = Abs(256*( syf + cxf + ca ))
			Local bindex:Int = Abs(256*( ca + sa ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma3(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			' very cool
			Local sxf:Float = Sin(x*scaleX*factor)
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local cxf:Float = Cos(x*scaleX*factor)
			Local sa:Float = Sin(angle)
			Local ca:Float = Cos(angle)
			Local rindex:Int = Abs(256*( sxf + cyf + sa ))
			Local gindex:Int = Abs(256*( syf + cxf + ca ))
			Local bindex:Int = Abs(256*( ca + sa + cyf + sxf ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma4(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			Local sxf:Float = Sin(x*scaleX*factor)
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local cxf:Float = Cos(x*scaleX*factor)
			Local sa:Float = Sin(angle)
			Local ca:Float = Cos(angle)
			Local rindex:Int = Abs(256*( sxf + cyf + Sin(angle/45*(x/2)) ))
			Local gindex:Int = Abs(256*( syf + cxf + Cos(angle/45*(y/2)) ))
			Local bindex:Int = Abs(256*( ca + sa ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma5(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local cxf:Float = Cos(x*scaleX*factor)
			Local sa:Float = Sin(angle)
			Local ca:Float = Cos(angle)
			Local rindex:Int = Abs(256*( syf + sa ))
			Local gindex:Int = Abs(256*( cyf + ca ))
			Local bindex:Int = Abs(256*( cxf + sa ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma6(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			Local syf:Float = Sin(y*scaleY*factor)
			Local cyf:Float = Cos(y*scaleY*factor)
			Local rindex:Int = Abs(256*( cyf + Cos(angle*x/factor) ))
			Local gindex:Int = Abs(256*( syf + Cos(angle*x/factor) ))
			Local bindex:Int = Abs(256*( cyf + Cos(angle*x/factor) ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function Plasma7(factor:Float)
	SetScale(scaleX,scaleY)
	Local xlimit:Int = GraphicsWidth()/scaleX
	Local ylimit:Int = GraphicsHeight()/scaleY
	For Local x:Int = 0 To xlimit
		For Local y:Int = 0 To ylimit
			Local sxf:Float = Sin(x*scaleX*factor)
			Local cxf:Float = Cos(x*scaleX*factor)
			Local rindex:Int = Abs(256*( cxf + Cos(angle*y/factor) ))
			Local gindex:Int = Abs(256*( sxf + Cos(angle*y/factor) ))
			Local bindex:Int = Abs(256*( cxf + Cos(angle*y/factor) ))
			SetColor rindex,gindex,bindex
			ScaleDrawRect(x,y,1,1)
		Next
	Next
End Function

Function ScaleDrawRect(x:Int,y:Int,w:Int,h:Int)
	Local sx:Float,sy:Float
	GetScale(sx,sy)
	DrawRect(sx*x,sy*y,w,h)
End Function

