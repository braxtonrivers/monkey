
'Simple black/white shader effect

Import mojo2

'Our custom shader
Class BWShader Extends Shader

	Method New()
		Build( LoadString( "monkey://data/bwshader.glsl" ) )
	End
	
	'must implement this - sets valid/default material params
	Method OnInitMaterial:Void( material:Material )
		material.SetTexture "ColorTexture",Texture.White()
		material.SetScalar "EffectLevel",1
	End
	
	Function Instance:BWShader()
		If Not _instance _instance=New BWShader
		Return _instance
	End
	
	Private
	
	Global _instance:BWShader
	
End

Class ShaderEffect

	Method New()
		If Not _canvas _canvas=New Canvas

		_material=New Material( BWShader.Instance() )
	End
	
	Method SetLevel:Void( level:Float )
	
		_material.SetScalar "EffectLevel",level
	End
	
	Method Render:Void( source:Image,target:Image )
	
		_material.SetTexture "ColorTexture",source.Material.ColorTexture
		
		_canvas.SetRenderTarget target
		_canvas.SetViewport 0,0,target.Width,target.Height
		_canvas.SetProjection2d 0,target.Width,0,target.Height
		
		_canvas.DrawRect 0,0,target.Width,target.Height,_material
		
		_canvas.Flush
	End
	
	Private
	
	Global _canvas:Canvas	'shared between ALL effects
	
	Field _material:Material
	
End


Class MyApp Extends App

	Field sourceImage:Image
	Field targetImage:Image
	
	Field canvas:Canvas
	
	Field effect:ShaderEffect
	
	Field level:Float=1
	
	Method OnCreate()
		
		sourceImage=Image.Load( "default_player.png" )
		targetImage=New Image( sourceImage.Width,sourceImage.Height )
		
		effect=New ShaderEffect

		canvas=New Canvas
	End
	
	Method OnUpdate()
		If KeyDown( KEY_A )
			level=Min( level+.01,1.0 )
		Else If KeyDown( KEY_Z )
			level=Max( level-.01,0.0 )
		Endif
	End
	
	Method OnRender()
	
		effect.SetLevel level
	
		effect.Render( sourceImage,targetImage )
		
		canvas.Clear
		
		canvas.DrawImage targetImage,MouseX,MouseY
		
		canvas.DrawText "Effect level="+level+" (A/Z to change)",0,0
		
		canvas.Flush
	End
	
End

Function Main()
	New MyApp
End

