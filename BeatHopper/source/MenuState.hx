package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var beat:FlxSprite;
	var hopper:FlxGroup;
	
	var bg:FlxSprite;
	
	var text : FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		FlxG.camera.zoom = 2;
		
		bg = new FlxSprite(-1, 0);
		bg.makeGraphic(251, 240, FlxColor.WHITE);
		FlxTween.color(bg, 1, bg.color, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 0.8, 0.5), 1, 1, { ease : FlxEase.quadInOut, complete: colorShift, type: FlxTween.ONESHOT } );
		bg.scrollFactor.set(0);
		
		add(bg);
		
		beat = new FlxSprite(-5, 20);
		beat.loadGraphic("assets/images/BEAT.png");
		
		hopper = new FlxGroup();
		
		var x:Float = 95;
		var letter : FloatyText = new FloatyText(x, 20, 0);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 40, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		x += 27;
		letter = new FloatyText(x, 40, 1);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 20, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		x += 25;
		letter = new FloatyText(x, 20, 2);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 40, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		x += 22;
		letter = new FloatyText(x, 40, 2);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 20, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		x += 22;
		letter = new FloatyText(x, 20, 3);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 40, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		x += 22;
		letter = new FloatyText(x, 40, 4);
		hopper.add(letter);
		FlxTween.linearMotion(letter, x, letter.y, x, 20, 1, true, { ease:FlxEase.quadInOut, type:FlxTween.PINGPONG } );
		
		add(beat);
		add(hopper);
		
		text = new FlxText(20, 150, 500, "Press Enter to start.\nControls: 1-4 (recommended) or arrow keys.\nDodge the barriers!\nR to restart!\nMade by William Osborne for the \nBAFTA Young Game Designers competition.");
		add(text);
		
		FlxG.sound.playMusic("assets/music/bu-boats-of-a-gun2.mp3");
		super.create();
	}
	
	public function colorShift(lol:FlxTween) 
	{
		FlxTween.color(bg, 1, bg.color, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.8, 0.5), 1, 1, { ease : FlxEase.quadInOut, complete: colorShift, type: FlxTween.ONESHOT } );
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.ENTER) {
			FlxG.switchState(new PlayState());
		}
		super.update();
	}	
}