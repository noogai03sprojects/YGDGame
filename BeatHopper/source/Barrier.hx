package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Noogai03
 */
class Barrier extends FlxSprite 
{
	public var lethal:Bool;
	public function new() 
	{
		super(0, 0);
		makeGraphic(32, 16, 0xFFDFDFDF);		
		//FlxColor
		color = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.9, 0.8);
		FlxSpriteUtil.drawLine(this, 2, 1, 29, 1, { color:FlxColor.WHITE, thickness:2 } );
		FlxSpriteUtil.drawLine(this, 1, 0, 1, 13, { color:FlxColor.WHITE, thickness:2 } );
		FlxSpriteUtil.drawLine(this, 3, 15, 32, 15, { color:0xffB0B0B0, thickness:2 } );
		FlxSpriteUtil.drawLine(this, 31, 3, 31, 16, { color:0xffB0B0B0, thickness:2 } );
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		velocity.y = Reg.speed;
		lethal = true;
		visible = true;
		solid = true;
	}
	
	override public function update():Void 
	{
		if (!isOnScreen())
		{
			kill();
		}
		super.update();
	}
	
}