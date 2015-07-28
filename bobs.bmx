'code by http://www.dbfinteractive.com/forum/index.php?action=profile;u=37

Graphics 800,600,0
Local bobImage:TImage = LoadImage( "images/sphere.png" ) ' load the image we use for the bobs
MidHandleImage bobImage ' set the handle to the center

Local i:Int, bobXadd:Int, bobYadd:Int, bobUpdate

Local bobx[64], boby[64] ' setup placeholders for x and y position for the bobs
For i = 0 To 63
bobx( i ) = i * 4 Mod 360 ' space the positions out a little
boby( i ) = i * 3 Mod 360 ' using Mod to keep the numbers between 0 and 360
Next

bobXadd = 1 ' this is the values we add to move the bobs
bobYadd = 2 ' change these For different patterns

While Not KeyHit(1)

Cls

For i = 0 To 63
DrawImage bobImage, 400 + Sin( bobx[i] ) * 304, 240 + Sin( boby[i] ) * 224 ' draw the bobs onto the screen
Next

If MilliSecs() > bobsUpdate + 15 Then ' here we find the next position of the bobs
bobsUpdate = MilliSecs()
For i = 0 To 63
bobx[i] = bobx[i] + bobXadd Mod 360
boby[i] = boby[i] + bobYadd Mod 360
Next
End If

Flip

Wend
End
