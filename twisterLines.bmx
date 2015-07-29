'http://www.socoder.net/index.php?snippet=28557
'Twisters Demo in just 9 Lines of Codes! by Hotshot |
Const xRes = 800,yRes = 600,Pos1=175,Pos2=375;Global a#,x1#,x2#,x3#,x4#,ang#=0,amp#=7,HideMouse;Type Twister;Field X1#,X2#,X3#,X4#;Function twister();For a=1 To 600 Step 2;x1=((Sin((a/amp)+ang))*100)+300;x2=((Sin((a/amp)+ang+90))*100)+300;x3=((Sin((a/amp)+ang+90*2))*100)+300;x4=((Sin((a/amp)+ang+90*3))*100)+300;SetColor 255,0,255;If x1<x2
			DrawLine x1-Pos1,a,x2-Pos1,a;DrawLine x1+Pos2,a,x2+Pos2,a;End If			
			SetColor 0,0,255;If x2<x3
			   DrawLine x2-Pos1,a,x3-Pos1,a;DrawLine x2+Pos2,a,x3+Pos2,a;End If			
			SetColor 0,255,0;If x3<x4
			   DrawLine x3-Pos1,a,x4-Pos1,a;DrawLine x3+Pos2,a,x4+Pos2,a;End If		
			SetColor 255,255,0;If x4<x1
			   DrawLine x4-Pos1,a,x1-Pos1,a;DrawLine x4+Pos2,a,x1+Pos2,a;End If;Next;ang=ang+2;If ang=360 Then ang=0
End Function;End Type;SetGraphicsDriver GLMax2DDriver();Graphics xRes,yRes,0;Global _Draw:Twister=New Twister;Repeat;_Draw.twister();Flip;Cls;Delay 20;Until KeyDown(KEY_ESCAPE);End


