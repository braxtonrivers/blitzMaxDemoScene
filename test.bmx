SuperStrict
Rem
  algoritm:
   0 No antialias
   1 Unweighted antialiasing
   2 Weighted antialiasing
EndRem

' This sets the width of the block where only one pixel is selected
' It should be a multiple of 2
Const BW:Int = 2
Const W4S:Int = (8-BW/2)
Const W2W:Int = (BW)
Const W2H:Int = (8-BW/2)
Const CX1B:Float = (0.5-BW/2)
Const CY1B:Float = (8.5)
Const CX2B:Float = (0.5-BW/2)
Const CY2B:Float = (-7.5)
Const C1X:Float = 8.5
Const C1Y:Float = 8.5
Const C2X:Float =-7.5
Const C2Y:Float = 8.5
Const C3X:Float = 8.5
Const C3Y:Float =-7.5
Const C4X:Float =-7.5
Const C4Y:Float =-7.5

Const PRECISION:Int = 256'

Global clrColour:Int=0
Global algoritm:Int=0
Global BytesPerPixel:Int[] = [0,1,1,3,3,4,4]
Global convTableW4:Byte[W4S*W4S*4]
Global convTableW2:Byte[W2W*W2H*2]

Function putPixel(image:TPixmap, x%, y%, pixel%)

  Local mem:Byte Ptr, bpp:Int
  bpp = BytesPerPixel[image.format]
  mem = image.pixels+y*image.pitch+x*bpp
      
  Select bpp 
  	Case 1 mem[0] = Byte(pixel)
  	Case 2 mem[0] = pixel
  	Case 3 
    	mem[0] = (pixel & $FF) 
    	mem[1] = (pixel Shr 8) & $FF
    	mem[2] = (pixel Shr 16) & $FF
  	Case 4 Int Ptr(mem)[0] = pixel '4 Byte/pixel
  End Select

End Function

'** getPixel ***/

Function  getPixel:Int(image:TPixmap, x%, y%)
  Local pixel:Int
  Local mem:Byte Ptr, bpp:Int
  If((x<0) Or (y<0) Or (x>=image.width) Or (y>=image.height)) Return clrColour
  bpp = BytesPerPixel[image.format]
  mem = image.pixels +y*image.pitch+x*bpp
  Select bpp
  	Case 1 Return mem[0]
  	Case 2 Return mem[0]|(mem[0] Shl 8)
  	Case 3 '24 bit pixel
    	Local r:Int, g:Int, b:Int
    	r = mem[0]
    	g = mem[1]
    	b = mem[2]
    	Return  r  | (g Shl 8) | (b Shl 16)
  	Case 4 Return Int Ptr(mem)[0]
  End Select  
End Function


Function mid2:Int(p1%, p2%)

  Local r:Int, g:Int, b:Int,a:Int
  a = (((p1 Shr 24) & $ff)+((p2 Shr 24) & $ff)) Shr 1
  r = (((p1 Shr 16) & $ff)+((p2 Shr 16) & $ff)) Shr 1
  g = (((p1 Shr 8 ) & $ff)+((p2 Shr 8 ) & $ff)) Shr 1
  b = ((p1 & $ff)+(p2 & $ff)) Shr 1
  Return (a Shl 24)|(r Shl 16) | (g Shl 8) | b

End Function

Function mid4:Int(p1%, p2%, p3%, p4%)

  Local  r:Int, g:Int, b:Int,a:Int
  a = ( ((p1 Shr 24)&$ff)+((p2 Shr 24)&$ff)+((p3 Shr 24)&$ff)+((p4 Shr 24)&$ff))Shr 2
  r = ( ((p1 Shr 16)&$ff)+((p2 Shr 16)&$ff)+((p3 Shr 16)&$ff)+((p4 Shr 16)&$ff))Shr 2
  g = ( ((p1 Shr  8)&$ff)+((p2 Shr  8)&$ff)+((p3 Shr 8) &$ff)+((p4 Shr 8 )&$ff))Shr 2
  b = ( (p1 &$ff)+(p2 &$ff)+(p3 &$ff)+(p4 &$ff) )  Shr  2
  Return (a Shl 24)|(r Shl 16)|(g Shl 8)|b

End Function

Function calcPixel:Int(image:TPixmap, xpos%, ypos%)

  Local x%, y%, px%, py%
  Local pixelSelect:Int

  x = xpos Shr 8
  y = ypos Shr 8
  px = xpos Shr 4
  py = ypos Shr 4
  px = px & $f
  py = py & $f

  pixelSelect = 0
  If(px >= 12) pixelSelect :| 4
  If(py >= 12) pixelSelect :| 8
  If(px < 4)   pixelSelect :| 2
  If(py < 4)   pixelSelect :| 1

  Select pixelSelect
  Case 0                   ' Pick one pixel
    Return getPixel(image,x,y)
  Case 1                   ' Weight two pixels, up
    Return mid2(getPixel(image,x,y),getPixel(image,x,y-1))
  Case 2                   ' Weight two pixels, Left
    Return mid2(getPixel(image,x,y), getPixel(image,x-1,y))
  Case 3                   ' Weight four pixels, Upper Left
    Return mid4(getPixel(image,x,y), getPixel(image,x-1,y),getPixel(image,x,y-1),getPixel(image,x-1,y-1))
  Case 4                   ' Weight two pixels, Right
    Return mid2(getPixel(image, x,y),getPixel(image,x+1,y))
  Case 5                   ' Weight four pixels, Upper Right
    Return mid4(getPixel(image,x,y),getPixel(image,x+1,y),getPixel(image,x,y-1),getPixel(image,x+1,y-1))
  Case 8                   ' Weight two pixels, Lower
    Return mid2(getPixel(image,x,y),getPixel(image,x,y+1))
  Case 10                  ' Weight four pixels, Lower Left
    Return mid4(getPixel(image,x,y),getPixel(image,x-1,y),getPixel(image,x,y+1),getPixel(image,x-1,y+1))
  Case 12                  ' Weight four pixels, Lower Right
    Return mid4(getPixel(image,x,y),getPixel(image,x+1,y),getPixel(image,x,y+1),getPixel(image,x+1,y+1))
  End Select


End Function

Function midw2:Int(p1%, p2%, px%, py%)

  Local r:Int, g:Int, b:Int,a:Int
  Local w1:Int, w2:Int

  If(px+py)>(W2W-1+W2H-1) Notify " Out of bounds!"

  w1 = convTableW2[(px+py*W2W) Shl 1]
  w2 = convTableW2[(px+py*W2W) Shl 1+1]
  a = ( ((p1 Shr 24)&$ff)*w1 + ((p2 Shr 24)&$ff)*w2 )  Shr  5
  r = ( ((p1 Shr 16)&$ff)*w1 + ((p2 Shr 16)&$ff)*w2 )  Shr  5
  g = ( ((p1 Shr 8)&$ff )*w1 + ((p2 Shr 8 )&$ff)*w2 )  Shr  5
  b = ( (p1&$ff)*w1 +( p2&$ff)*w2 )  Shr  5
  Return (a Shl 24) | (r Shl 16) | (g Shl 8) | b
End Function 

Function midw4:Int(p1%, p2%, p3%, p4%, wx%, wy%)

  Local x:Int
  Local r:Int, g:Int, b:Int,a:Int
  Local w1:Int, w2:Int, w3:Int, w4:Int
  Local convTable2:Int[] = [0,1,2,3,4,5,6,7,7,6,5,4,3,2,1,0]

  wx = convTable2[wx]
  wy = convTable2[wy]

  w1 = convTableW4[(wx+wy*W4S)Shl 2+ 0]
  w2 = convTableW4[(wx+wy*W4S)Shl 2+ 1]
  w3 = convTableW4[(wx+wy*W4S)Shl 2+ 2]
  w4 = convTableW4[(wx+wy*W4S)Shl 2+ 3]
  a = (((p1 Shr 24)&$ff)*w1+((p2 Shr 24)&$ff)*w2+((p3 Shr 24)&$ff)*w3+((p4 Shr 24)&$ff)*w4)Shr  5
  r = (((p1 Shr 16)&$ff)*w1+((p2 Shr 16)&$ff)*w2+((p3 Shr 16)&$ff)*w3+((p4 Shr 16)&$ff)*w4)Shr  5
  g = (((p1 Shr 8)&$ff)*w1+((p2 Shr 8)&$ff)*w2+((p3 Shr 8 )&$ff)*w3+((p4 Shr 8)&$ff)*w4)Shr 5
  b =  ((p1&$ff)*w1+(p2&$ff)*w2+(p3&$ff)*w3+(p4&$ff)*w4 )Shr  5
  Return (r Shl 16) | (g Shl 8) | b
End Function

Function rint:Float(n:Float)
	If n<0 	Return Floor(n)
	If n> 0 Return Ceil(n)
	Return n
End Function


Function  calcWeightedPixel:Int(image:TPixmap, xpos%, ypos%)
  Local x%, y%, px%, py%
  Local pixelSelect:Int
  Local p1%, p2%, p3%, p4%

  x = xpos Shr 8
  y = ypos Shr 8
  px = xpos Shr 4
  py = ypos Shr 4
  px = px & $f
  py = py & $f

  pixelSelect = 0
  If(px >= (8+BW/2)) pixelSelect :| 4
  If(py >= (8+BW/2)) pixelSelect :| 8
  If(px < (8-BW/2))  pixelSelect :| 2
  If(py < (8-BW/2))  pixelSelect :| 1
 
  Select pixelSelect
  Case 0                   ' Pick one pixel
    Return getPixel(image, x, y)
    
  Case 1                   ' Weight two pixels, up
    p1 = getPixel(image, x, y-1)
    p2 = getPixel(image, x, y)
    Return midw2(p1, p2, px-(8-BW/2), py)
    
  Case 2                   ' Weight two pixels, Left
    p1 = getPixel(image, x-1, y)
    p2 = getPixel(image, x, y)
    Return midw2(p1, p2, py-(8-BW/2), px)
    
  Case 3                   ' Weight four pixels, up Left
    p1 = getPixel(image, x-1, y-1)
    p2 = getPixel(image, x, y-1)
    p3 = getPixel(image, x-1, y)
    p4 = getPixel(image, x, y)
    Return midw4(p1, p2, p3, p4, px, py)
    
  Case 4                   ' Weight two pixels, Right
    p1 = getPixel(image, x+1, y)
    p2 = getPixel(image, x, y)
    Return midw2(p1, p2, py-(8-BW/2), 15-px)
    
  Case 5                   ' Weight four pixels, up Right
    p1 = getPixel(image, x+1, y-1)
    p2 = getPixel(image, x, y-1)
    p3 = getPixel(image, x+1, y)
    p4 = getPixel(image, x, y)
    Return midw4(p1, p2, p3, p4, px, py)
  Case 8                   ' Weight two pixels, down
    p1 = getPixel(image, x, y+1)
    p2 = getPixel(image, x, y)
    Return midw2(p1, p2, px-(8-BW/2), 15-py)
    
    
  Case 10                  ' Weight four pixels, down Left
    p1 = getPixel(image, x-1, y+1)
    p2 = getPixel(image, x, y+1)
    p3 = getPixel(image, x-1, y)
    p4 = getPixel(image, x, y)
    Return midw4(p1, p2, p3, p4, px, py)
    
  Case 12                  ' Weight four pixels, down Right
    p1 = getPixel(image, x+1, y+1)
    p2 = getPixel(image, x, y+1)
    p3 = getPixel(image, x+1, y)
    p4 = getPixel(image, x, y)
    Return midw4(p1, p2, p3, p4, px, py)
  End Select
End Function 

Function drawRotateImage(image:TPixmap, canvas:TPixmap, v#)

  Local x%, y%
  Local mag% = 1

  '--------- Beginning of rotate routine ------------

  Local sinv:Int, cosv:Int        ' Holds sinus And cosius values
  Local startx:Int, starty:Int    ' Holds start values
  Local zoom:Int,pw:Int,ph:Int
  Local imagePosX:Int, imagePosY:Int
  Local tmpImagePosX:Int, tmpImagePosY:Int
  Local pixelSelect:Int
  Local px:Int, py:Int
  
  Local pixel:Int
  Local src:Byte Ptr, dest:Byte Ptr, srcbpp:Int, destbpp:Int

  zoom = 100

  sinv = rint((Sin(v)*PRECISION))
  cosv = rint((Cos(v)*PRECISION))

  startx = (Image.Width Shr 1)*PRECISION + PRECISION Shr 1
  starty = (Image.Height Shr 1)*PRECISION + PRECISION Shr 1
  
  startx :+ (Canvas.Width Shr 1)*(-cosv) + (Canvas.height Shr 1)*sinv
  starty :- (Canvas.Width Shr 1)* sinv + (Canvas.Height Shr 1)*cosv

  '************** First Field *****************/
  
  '--- Start of Y-loop
  imagePosX = startx
  imagePosY = starty
  pw = Canvas.Width*PRECISION  
  ph = Canvas.Height*PRECISION
  For y=0 Until Canvas.Height Step 2
    ' Make temp copies of image counters For use in x loop
    tmpImagePosX = imagePosX
    tmpImagePosY = imagePosY
    ' Update image pos counter For Next row
    imagePosX = imagePosX - sinv Shl 1
    imagePosY = imagePosY + cosv Shl 1
    '--- Start of X-loop
    For x = 0 Until Canvas.Width
      pixel = clrColour ' Default colour For cleared corners
      If((tmpImagePosX>0) & (tmpImagePosX<(pw)) & (tmpImagePosY>0) & (tmpImagePosY<ph))  
		Select(algoritm)
			Case 0 pixel = getPixel(image, tmpImagePosX Shr 8, tmpImagePosY Shr 8)
			Case 1 pixel = calcPixel(image, tmpImagePosX, tmpImagePosY)
			Case 2 pixel = calcWeightedPixel(image, tmpImagePosX, tmpImagePosY)
		End Select
      EndIf	
      tmpImagePosX = tmpImagePosX + cosv
      tmpImagePosY = tmpImagePosY + sinv
      putPixel(canvas, x, y, pixel)
    Next
  Next
	  

  '************** Second Field *****************/
  imagePosX = startx - sinv
  imagePosY = starty + cosv
  '--- Start of Y-loop
  For y = 0 Until Canvas.Height Step 2
    ' Make temp copies of image counters For use in x loop
    tmpImagePosX = imagePosX
    tmpImagePosY = imagePosY
    ' One Step For odd frames
    imagePosX = imagePosX - sinv Shl 1
    imagePosY = imagePosY + cosv Shl 1
    '--- Start of X-loop
    For x = 0 Until Canvas.Width 
      pixel = clrColour ' Default colour For cleared corners
      If((tmpImagePosX>0) & (tmpImagePosX<(pw)) & (tmpImagePosY>0) & (tmpImagePosY<ph)) 
		Select(algoritm)
			Case 0 pixel = getPixel(image, tmpImagePosX Shr 8, tmpImagePosY Shr 8)
			Case 1 pixel = calcPixel(image, tmpImagePosX, tmpImagePosY)
			Case 2 pixel = calcWeightedPixel(image, tmpImagePosX, tmpImagePosY)
		End Select
      EndIf
      ' Update temp image pos counter For Next pixel in row
      tmpImagePosX = tmpImagePosX + cosv
      tmpImagePosY = tmpImagePosY + sinv
      putPixel(canvas, x, y+1, pixel)
    Next
  Next
  '------------ End of rotate routine ---------------
End Function 

Function invl:Double(l:Double)

  l = 15 - l
  If(l<0) l = 0
  Return l
End Function


Function scalar4:Double(w1:Double, w2:Double, w3:Double, w4:Double)

  Return 32.0/(w1+w2+w3+w4)
End Function 

Function scalar2:Double(w1:Double, w2:Double)

  Return 32/(w1+w2)
End Function 


Function calcTables()

  Local x:Int, y:Int, i:Int
  Local l1:Double, l2:Double, l3:Double, l4:Double
  Local w1:Int, w2:Int, w3:Int, w4:Int
  Local s:Double
  Local d1:Double, d2:Double, d3:Double, d4:Double
  ' Calc 4-weight table
  For y=0 Until (8-2/2)
    For x=0 Until (8-2/2)
		l1=invl(Sqr((C1X+x)*(C1X+x) + (C1Y+y)*(C1Y+y)))
		l2=invl(Sqr((C2X+x)*(C2X+x) + (C2Y+y)*(C2Y+y)))
		l3=invl(Sqr((C3X+x)*(C3X+x) + (C3Y+y)*(C3Y+y)))
		l4=invl(Sqr((C4X+x)*(C4X+x) + (C4Y+y)*(C4Y+y)))
		s = scalar4(l1, l2, l3, l4)
		w1 = rint(l1*s)
		w2 = rint(l2*s)
		w3 = rint(l3*s)
		w4 = rint(l4*s)
		If(w1+w2+w3+w4 <> 32) 
			d1 = Abs(l1*s-w1)
			d2 = Abs(l1*s-w1)
			d3 = Abs(l1*s-w1)
			d4 = Abs(l1*s-w1)
	  		If((d1<d2) And (d1<d3) And (d1<d4)) 
		  		w1 = w1 + (32-w1-w2-w3-w4)
			Else 
	    		If((d2<d3) & (d2<d4))
		    		w2 = w2 + (32-w1-w2-w3-w4)
	    		Else 
					If(d3<d4) w3 = w3 + (32-w1-w2-w3-w4) Else w4 = w4 + (32-w1-w2-w3-w4)
	    		EndIf
			EndIf
		EndIf
		convTableW4[(x+y*(8-2/2))*4+0] = w1
		convTableW4[(x+y*(8-2/2))*4+1] = w2
		convTableW4[(x+y*(8-2/2))*4+2] = w3
	    convTableW4[(x+y*(8-2/2))*4+3] = w4
    Next
  Next

  ' Calc 2-weight table
  For y = 0 Until (8-BW/2)
    For x=0 Until BW
      l1 = Sqr((CX1B+x)*(CX1B+x) + (CY1B+y)*(CY1B+y))
      l2 = Sqr((CX2B+x)*(CX2B+x) + (CY2B+y)*(CY2B+y))
      l1 = invl(l1)
      l2 = invl(l2)
      s = scalar2(l1, l2)
      w1 = rint(l1*s)
      w2 = rint(l2*s)
      If(w1+w2 <> 32) 
		If((Abs(l1*s-w1)) < (Abs(l2*s-w2))) 
	  		w1 = w1 + (32-w1-w2)
		Else 
	  		w2 = w2 + (32-w1-w2)
		EndIf
      EndIf
      convTableW2[(x+y*(2))*2 + 0] = w1
      convTableW2[(x+y*(2))*2 + 1] = w2
    Next
  Next

End Function
Function CreateCanvas:TPixmap(image:TPixmap)
 
	Local D% = Sqr((image.width)^2+(image.height)^2)+1
	D = (D Shr 1) Shl 1 
	Return CreatePixmap(D,D,image.format)

End Function 

Global fps:Float, fpst:Float,fpsc:Float

Function CountFPS:Float()
	If fpst < MilliSecs() Then
		fpst=MilliSecs()+1000
		fps = fpsc
		fpsc = 0
	Else
		fpsc = fpsc + 1
	End If
	Return fps
End Function

Local canvas:TPixmap
Local image:TPixmap
Local v:Float= 0,dv:Float
Local motion:Int=1,update:Int=0
Local getEvent:Int,i:Int,x:Int, y:Int

calcTables()
Graphics 640,480,32
image = LoadPixmap("images/island.png")
If (image = Null) Notify "Could not load file"
canvas = CreateCanvas(image)
While Not KeyDown(key_escape)
	Cls
	dv = 0
	update = motion
	Select True 
		Case KeyDown(KEY_UP) dv = dv + 01.5; update = 1
		Case KeyDown(KEY_DOWN) dv = dv - 01.5; update = 1
		Case KeyDown(KEY_LCONTROL) v = 0; dv = 0; update = 1	
		Case KeyDown(KEY_LEFT) clrColour :- $080808; update = 1
		Case KeyDown(KEY_RIGHT) clrColour :+ $080808; update = 1
		Case KeyDown(KEY_1)
			If(algoritm <>0) 
	    		algoritm = 0
	    		update = 1
	  		EndIf
		Case KeyDown(KEY_2) 
	  		If(algoritm <>1) 
	    		algoritm = 1
	    		update = 1
	  		EndIf
		Case KeyDown(KEY_3)
	  		If(algoritm<>2) 
	    		algoritm = 2
	    		update = 1
	  		EndIf
	End Select
	If((dv <> 0) | (update))
		v = v + dv
		drawRotateImage(image, canvas, v)
		motion = 0
	EndIf
	    
	DrawPixmap canvas,150,100
	DrawText ("FPS:"+(Int(CountFPS())),20,0)
	DrawText "1: No antialias",20,15
	DrawText "2: Unweighted antialiasing",20,30
	DrawText "3: Weighted antialiasing", 20 ,45
	DrawText "Left/Rigth: arrow canvas color",20,60
	DrawText "Up/Down: set Rotation angle",20,75
	DrawText "image Width  = "+image.width,300,15
	DrawText "image height = "+image.height,300,30
	DrawText "canvas width = "+canvas.width,300,45
	DrawText "canvas Height= "+canvas.height,300,60
	
	Flip(0)
Wend

