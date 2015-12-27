package;
import flixel.FlxSprite;

/**
 * ...
 * @author Noogai03
 */
class FloatyText extends FlxSprite 
{

	public function new(X :Float, Y:Float, index:Int) 
	{
		super(X, Y);
		loadGraphic("assets/images/hopper.png", true, false, 40, 40);
		animation.frameIndex = index;		
	}
	
}