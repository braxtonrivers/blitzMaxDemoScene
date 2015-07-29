Graphics 800,600

Local pmap:TPixmap = LoadPixmap("images/island.jpg")
Local image:TImage = LoadImage("images/island.jpg",0)

Local time:Int = 0
Local utime:Int = 0

Local fps:Int = 0
Local fpstmp:Int = 0
Local update:Int = MilliSecs()

While Not KeyHit(KEY_ESCAPE)

	Cls
	DrawImage(image,0,0)
	DrawText("Current FPS: "+fps,8,520)
	DrawText("Last image update time in millisecs: "+utime,8,540)
	Flip False
	
	If KeyHit(KEY_LEFT) Then
		time = MilliSecs()
		image=shiftPmapLeft(pmap,32)
		utime = MilliSecs()-time
	End If
	If KeyHit(KEY_RIGHT) Then
		time = MilliSecs()
		image=shiftPmapRight(pmap,32)
		utime = MilliSecs()-time
	End If
	If KeyHit(KEY_UP) Then
		time = MilliSecs()
		image=shiftPmapUp(pmap,32)
		utime = MilliSecs()-time
	End If
	If KeyHit(KEY_DOWN) Then
		time = MilliSecs()
		image=shiftPmapDown(pmap,32)
		utime = MilliSecs()-time
	End If

	fpstmp :+ 1
	If MilliSecs() > update+1000 Then
		update = MilliSecs()
		fps = fpstmp
		fpstmp = 0
	End If

Wend
End

Function shiftPmapLeft:TImage(pix:TPixmap,shift:Int)
	Local pixPtr:Byte Ptr = PixmapPixelPtr(pix)
	Local pitch:Int = PixmapPitch(pix)
	Local pixSize:Int = pitch/PixmapWidth(pix)
	Local moveSize:Int = (PixmapWidth(pix)-shift)*pixSize
	Local offset:Int = shift*pixSize
	For Local y:Int = 0 To PixmapHeight(pix)-1
		MemCopy(pixPtr,pixPtr+offset,moveSize)
		pixPtr :+ pitch
	Next
	Return LoadImage(pix,0)
End Function

Function shiftPmapRight:TImage(pix:TPixmap,shift:Int)
	Local pixPtr:Byte Ptr = PixmapPixelPtr(pix)
	Local pitch:Int = PixmapPitch(pix)
	Local pixSize:Int = pitch/PixmapWidth(pix)
	Local moveSize:Int = (PixmapWidth(pix)-shift)*pixSize
	Local offset:Int = shift*pixSize
	For Local y:Int = 0 To PixmapHeight(pix)-1
		MemCopy(pixPtr+offset,pixPtr,moveSize)
		pixPtr :+ pitch
	Next
	Return LoadImage(pix,0)
End Function

Function shiftPmapUp:TImage(pix:TPixmap,shift:Int)
	Local pixPtr:Byte Ptr = PixmapPixelPtr(pix)
	Local pitch:Int = PixmapPitch(pix)
	Local pixSize:Int = pitch/PixmapWidth(pix)
	For Local y:Int = 0 To PixmapHeight(pix)-1-shift
		MemCopy(pixPtr,pixPtr+pitch*shift,pitch)
		pixPtr :+ pitch
	Next
	Return LoadImage(pix,0)
End Function

Function shiftPmapDown:TImage(pix:TPixmap,shift:Int)
	Local pixPtr:Byte Ptr = PixmapPixelPtr(pix)
	Local pitch:Int = PixmapPitch(pix)
	Local pixSize:Int = pitch/PixmapWidth(pix)
	pixPtr :+ ((PixmapWidth(pix)*pixSize)*(PixmapHeight(pix)-1))
	For Local y:Int = 0 To PixmapHeight(pix)-1-shift
		MemCopy(pixPtr,pixPtr-(pitch*shift),pitch)
		pixPtr :- pitch
	Next
	Return LoadImage(pix,0)
End Function