' // Sine Wave Scroller by Shockwave, Adapted by P0T N00DLE.
' http://www.dbfinteractive.com/forum/index.php?topic=5351.0

SetGraphicsDriver (GLMax2DDriver(), GRAPHICS_BACKBUFFER | GRAPHICS_STENCILBUFFER | GRAPHICS_ALPHABUFFER)
	
	Const xRes = 800' Screen Width
	Const yRes = 600' Screen Height
	
   	Graphics xRes, yRes, 32, 60
	
	'// Setup our mask color Black.
	SetMaskColor(0, 0, 0)
	
	'// Load the font
	Global Font = LoadAnimImage("images/sfont16.bmp", 1, 16, 0, 944, MASKEDIMAGE)
	
	'// Load the background image.
	Global Background:TImage = LoadImage("images/island.png")

	Global ScrollText:String	          ' // String to hold the text.
	Global Tpos:Int			  ' // Position in text string.
	Global ScrlPos:Int			  ' // Scroll Offset.
	Global Sineadd:Int
		
	ScrollText ="                                                      "
	ScrollText = ScrollText + "Just a small example of how to make a colourfull scroll routine...      "
	ScrollText = ScrollText + "The Scroll routine was done by shockwave, the rest was my fault!      Wrap! "
	ScrollText=ScrollText+"                                                     "	
	
	ScrollText = Upper(ScrollText)     ' // Convert to uppercase
        Tpos = 1					  ' // Position in string
	ScrlPos = 0				  ' // ScrollOffset
	Sineadd = 0

	' // Start of the Opengl stuff.
	' // Look these up on the net as thay can be a bit long winded. 
	glEnable(GL_STENCIL_TEST)
	glDepthMask(GL_FALSE)
	glStencilMask($ffffff)
	SetBlend SOLIDBLEND
    
	' // Main loop.	
	Repeat
	
		Cls
		' // more Opengl
		glClearStencil(0)
		glClear(GL_STENCIL_BUFFER_BIT)
		glDisable(GL_STENCIL_TEST)
		
		Sineadd:-2
		
		glEnable(GL_ALPHA_TEST)
		glEnable(GL_STENCIL_TEST)
		glStencilOp(GL_REPLACE, GL_REPLACE, GL_REPLACE)
		glStencilFunc(GL_ALWAYS, $ffffff, $ffffff)

		Do_Scroller() 			  ' // Call scroll function

		glStencilOp(GL_KEEP, GL_KEEP, GL_KEEP)
		glStencilFunc(GL_EQUAL, $ffffff, $ffffff)
		glDisable(GL_ALPHA_TEST)

		DrawImage Background, 0, 0' // Draw the background.

		Flip(-1)				      ' // Swap buffers
	
	Until KeyDown(KEY_ESCAPE)
    		
	EndGraphics
	End

Function Do_Scroller()
	ScrlPos:+2			           ' // Move the scroll offset.
	If ScrlPos > 16 Then		           ' // If the text has scrolled more than the char width, ..
							   ' // reset scroll pointer and advance text pointer
		ScrlPos:-16
		Tpos:+1
							   ' // Make sure that the text pointer hasn't gone out of bounds
		If Tpos > Len(ScrollText) - 52 Then Tpos = 1
	End If
	Local DrawPos:Int
	Local TextAdd: Int
	Local Letter:  Int
	Local IL: Int
	TextAdd = 0				   ' // Step to different letters
	DrawPos = (-16) - ScrlPos	   ' // This is the current drawing position
		
        Repeat					   ' // Draw letters until we go off the screen.
		Letter = (Asc(Mid(ScrollText, (Tpos + TextAdd), 1)) - 32) * 16
		For IL = 0 To 15
			DrawImage Font, DrawPos + IL, 250 + (40 * Sin(Sineadd + Drawpos + IL)), Letter + IL
		Next
		TextAdd:+1
		DrawPos:+16
	Until DrawPos >= xRes
	
End Function
