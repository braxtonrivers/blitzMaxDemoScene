' Broken TV

SuperStrict

Const sw%=640,sh%=480

Const cellW%=256
Const cellH%=128
Const pixSize%=2

SetGraphicsDriver GLMax2DDriver()
Graphics sw,sh,32,50

Local tvimage:TImage=CreateImage(cellW,cellH,1,DYNAMICIMAGE)

Repeat
	Local x%,y%
	'
	For y%=0 Until cellH Step pixSize
		For x%=0 Until cellW Step pixSize
			Local c%=Rand(50,240)
			SetColor c,c+5,c+8
			DrawRect x,y,pixSize,pixSize
		Next
	Next
	'
	GrabImage tvimage,0,0
	SetColor $ff,$ff,$ff
	'
	x=cellW ; y=0
	While y<sh
		While x<sw
			DrawImage tvimage,x,y
			x:+cellW
		Wend
		x=0 ; y:+cellH
	Wend
	'
	Flip
Until KeyHit(KEY_ESCAPE)

End
