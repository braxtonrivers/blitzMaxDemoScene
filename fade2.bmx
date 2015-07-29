Strict

Global azero#=0.1 ' if these need to be Global
Global azero2#=0.1
Local change# = 0.1
Local change2# = 0.1
Local timer:TTimer = CreateTimer(10) ' frequency in Hertz
Local timer2:TTimer = CreateTimer(20)

SetGraphicsDriver GLMax2DDriver()
Graphics 800,600,0,60 'the 0 stands for debugging, 60 is the herts(FPS)

Local g_background:TImage = LoadImage("images/island.png") ' YOUR IMAGE GOES HERE

Repeat

	Delay 5 ' give any other apps a few CPU cycles - reduce or remove if more speed needed
	PollEvent ' check for events without halting like WaitEvent
	Cls
	
	SetBlend AlphaBlend
	SetAlpha(1)
	' Background
	DrawImage g_background,0,0
	
	' Text
	SetColor(165,220,225)
	SetAlpha(azero#)
	DrawText "Hello World",10,10
	If EventSource() = timer Then ' timer has ticked
		azero# = azero# + change#
		If azero > 1.0 Then change = -change ' "ping pong" between getting brighter and getting darker
		If azero < 0.1 Then change = -change
	EndIf

	' Other text
	SetColor(255,0,0)
	SetAlpha(azero2#)
	DrawText "I blink twice as fast",10,24
	If EventSource() = timer2 Then
		azero2# = azero2# + change2#
		If azero2 > 1.0 Then change2 = -change2
		If azero2 < 0.1 Then change2 = -change2
	EndIf
			
	' Return to no Color or Alpha
	SetColor(255,255,255)
	SetAlpha 1.0
	
	Flip

Until KeyHit(key_escape)

End
