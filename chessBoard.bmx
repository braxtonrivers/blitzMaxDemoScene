Strict

' ******************************************************************************************
' *                                                                                        *
' * 3D Chequerboard By Shockwave : www.Dbfinteractive.com                                  *
' * Apologies for this bodged code.. It's just thrown together to help someone out..       *  
' *                                                                                        *
' ******************************************************************************************
' http://www.dbfinteractive.com/forum/index.php?topic=5207.0
' *********************************************************************
' * Open Screen                                                       *
' *********************************************************************

	SetGraphicsDriver GLMax2DDriver()
	
	Const xres = 800
	Const yres = 600
	
	Const halfX = 400
	Const halfY = 250
	
	Graphics xres,yres,32,60,GRAPHICS_BACKBUFFER
	Const Grid = 30	: Int
	Const Size = 150 : Int
	
	Global GridX : Double[Grid,Grid]
	Global GridY : Double[Grid,Grid]
	Global GridZ : Double[Grid,Grid]

	Global Move : Double

	Move = 0.0
	SetGrid()
	
' *********************************************************************
' * Main Loop                                                         *
' *********************************************************************


	Repeat

		SetColor (255,255,255)
		
		DrawGrid()
		Move = Move + .025
		If Move >= .5 Then Move =Move -.5
		Flip(-1)
		Cls
	
	Until KeyDown(KEY_ESCAPE)

	EndGraphics
	End

' *********************************************************************
' * Functions                                                         *
' *********************************************************************

Function DrawGrid()

	Local Z : Int
	Local X : Int
	
	Local TX : Int
	Local TY : Int
	
	Local Clr     : Int
	Local Shade   : Int
	Local ClrStrt : Int

	ClrStrt=1
	
	Local PolyTransform : Float [8]

	For Z = 0 To Grid-2	
	
		ClrStrt=ClrStrt+1
		If ClrStrt>2 Then ClrStrt=1
		Clr = ClrStrt
		For X = 0 To Grid-2

			Clr=Clr+1
			If Clr>2 Then Clr=1
											
			TX = (GridX[X,Z]     / (GridZ[X,Z]-Move))+HalfX
			TY = (GridY[X,Z]     / (GridZ[X,Z]-Move))+HalfY			
			
			Polytransform[0]=TX
			Polytransform[1]=TY

			TX = (GridX[X+1,Z] / (GridZ[X+1,Z]-Move))+HalfX
			TY = (GridY[X+1,Z]     / (GridZ[X+1,Z]-Move))+HalfY			
			
			Polytransform[2]=TX
			Polytransform[3]=TY

			TX = (GridX[X+1,Z+1] / (GridZ[X+1,Z+1]-Move))+HalfX
			TY = (GridY[X+1,Z+1] / (GridZ[X+1,Z+1]-Move))+HalfY			
			
			Polytransform[4]=TX
			Polytransform[5]=TY

			TX = (GridX[X,Z+1] / (GridZ[X,Z+1]-Move))+HalfX
			TY = (GridY[X,Z+1] / (GridZ[X,Z+1]-Move))+HalfY			
			
			Polytransform[6]=TX
			Polytransform[7]=TY

			shade=(ty/4)-75
			If shade<0 Then shade=0

			If Clr =1 Then SetColor(Shade,Shade,Shade)
			If Clr =2 Then SetColor( 0, 0,Shade)			
			
		
			DrawPoly(Polytransform)
						
		Next
		
	Next


End Function


Function SetGrid()


	Local Xpos : Double
	Local Zpos : Double
	Local Ypos : Double
	Local Jump : Double
	Local Xscale : Double

	
	Local Z : Int
	Local X : Int
	
	Jump = Size / Grid

	Xscale = 25	
	Ypos = 400
	Zpos = 8.4
	
	For Z = 0 To Grid -1 

		Xpos = -((Size*Xscale) /2)	
	
			For X = 0 To Grid -1
					
				GridX[X,Z] = Xpos
				GridY[X,Z] = Ypos
				GridZ[X,Z] = Zpos
				
				Xpos = Xpos + (Jump*Xscale)
		
			Next		
		
		Zpos = Zpos - (Jump/20)
	
	Next

End Function
