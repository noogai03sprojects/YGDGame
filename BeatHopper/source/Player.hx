package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Noogai03
 */
class Player extends FlxSprite 
{
	public var lane:Int = 0;
	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.WHITE);
		color = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 1, 0.6);
	}
	
	override public function update():Void 
	{
		//noob controls
		if (FlxG.keys.justPressed.RIGHT)
			changeLane(lane + 1);
		if (FlxG.keys.justPressed.LEFT)
			changeLane(lane - 1);
			
		//pro controls
		if (FlxG.keys.justPressed.ONE)
			changeLane(0);
		if (FlxG.keys.justPressed.TWO)
			changeLane(1);
		if (FlxG.keys.justPressed.THREE)
			changeLane(2);
		if (FlxG.keys.justPressed.FOUR)
			changeLane(3);
		super.update();
	}
	
	public function changeLane ( _lane:Int) : Void {
		if (!Reg.paused) {
			//invalid lane; return
			if (_lane  > 3 || _lane < 0)
				return;
			lane = _lane;
		
			FlxTween.linearMotion(this, x, y, Reg.lanePositions[lane] - 8, y, 0.1, true, { ease : FlxEase.quadInOut, type : FlxTween.ONESHOT } );
		}
	}
}