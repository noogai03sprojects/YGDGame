package;
import flixel.effects.particles.FlxEmitter;
import FormationHandler;
import flixel.effects.particles.FlxParticle;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var barriers : FlxTypedGroup<Barrier>;
	var player : Player;
	
	var addTimer : Float = 0.75;
	var delay : Float = 0.75;
	
	var scoreLabel:FlxText;
	
	var handler : FormationHandler;
	var formationQueue : Array<Array<Int>>;
	
	var bg : FlxSprite;
	var spawning : Bool =  true;
	
	var emitter : FlxEmitter;
	//
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//FlxG.sound.muted = true;
		//FlxG.sound.music.loadEmbedded("assets/music/bu-wings-and-goats.mp3");
		FlxG.sound.playMusic("assets/music/bu-wings-and-goats.mp3");
		//FlxG.sound.playMusic("main1");
		//FlxG.sound.music.
		
		//bgColor = FlxColor.HOT_PINK;
		bgColor = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.8, 0.5);
		
		bg = new FlxSprite(0, 0);
		bg.makeGraphic(250, 240, FlxColor.WHITE);
		FlxTween.color(bg, 1, bg.color, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.8, 0.5), 1, 1, { ease : FlxEase.quadInOut, complete: colorShift, type: FlxTween.LOOPING } );
		bg.scrollFactor.set(0);
		
		barriers = new FlxTypedGroup<Barrier>();
		player = new Player(50, 200);
		
		FlxG.camera.zoom = 2;
		FlxG.camera.width = Std.int(FlxG.camera.width / 2);
		FlxG.camera.height = Std.int(FlxG.camera.height / 2);
		
		addTimer = delay;
		
		scoreLabel = new FlxText(10, 10, 400, "Score: 0");
		
		FlxG.autoPause = false;
		handler = new FormationHandler();
		formationQueue = new Array<Array<Int>>();
		
		emitter = new FlxEmitter(0, 0);
		
		var particle:FlxParticle;
		
		for (i in 0...400) {
			
			particle = new FlxParticle();
			particle.makeGraphic(6, 6, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.8, 0.8));
			//particle.alpha = 0.1;
			emitter.add(particle);
			//particle = new FlxParticle();
			//particle.makeGraphic(3, 3, FlxColor.FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 0.8, 0.8));
			//particle.alpha = 0.2;
			//emitter.add(particle);
			//particle = new FlxParticle();
			//particle.makeGraphic(3, 3, FlxColor.WHITE);
			//particle.alpha = 0.2;
			//emitter.add(particle);
		}
		
		
		//emitter.makeParticles(particle, 50, 0, false, 0);
		//emitter.particleDrag.set(0.9, 0.9);
		emitter.start(false, 1, -1, 0);
		emitter.on = false;
		
		FlxG.sound.volumeUpKeys = ["PLUS"];
		FlxG.sound.volumeDownKeys = ["MINUS"];
		
		
		add(bg);
		add(barriers);
		
		add(player);
		add(emitter);
		
		add(scoreLabel);
		
		Reg.gameOver = false;
		unpauseGame();
		
		super.create();
		handler.loadFormations();
		
	}
	
	function colorShift(lol:FlxTween) 
	{
		FlxTween.color(bg, 1, bg.color, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 359), 0.8, 0.5), 1, 1, { ease : FlxEase.quadInOut } );
	}
	
	//function colorShift() {
		//FlxTween.color(bg, 1, bg.color, FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 0.8, 0.5), 1, 1, { ease : FlxEase.quadInOut } );
	//}
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
		if (FlxG.keys.justPressed.SPACE)
			addFormation();
		if (FlxG.keys.justPressed.HOME)
			FlxG.debugger.visible = !FlxG.debugger.visible;
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (!Reg.gameOver)
			{
			if (Reg.paused)			
				unpauseGame();
			else 
				pauseGame();
			}
			else {
				FlxG.switchState(new MenuState() );
			}
		}
		if (FlxG.keys.justPressed.R)
			restartGame();
		
		if (FlxG.keys.pressed.RBRACKET) {
			setSpeed(Reg.speed + 1);
		}
		if (FlxG.keys.pressed.LBRACKET) {
			setSpeed(Reg.speed - 1);
		}
		
		if (!Reg.paused)
			addTimer -= FlxG.elapsed;
		if (addTimer < 0 && spawning)
		{
			addFormation();
			delay -= 0.03;
			if (delay < 0.4)
				delay = 0.4;
			addTimer = delay;
		}
		if (addTimer < -1.5)
		{
			/*
			 * LEVEL COMPLETE
			 * 
			 * 
			 * 
			 */
			//level complete
			FlxG.sound.play("assets/sounds/cheer2.wav");
			spawning = true;
			Reg.level++;
			addTimer = delay;
			Reg.dodgeCount = 0;
			setSpeed (Reg.speed + 10);
			Reg.score += 100;
			emitter.on = true;
			for (x in Reg.lanePositions) {
			emitter.setPosition(x, player.y);
			for (i in 0...75) {
				emitter.emitParticle();
			}
			}
			emitter.on = false;
		}
		
		 
		
		FlxG.overlap(player, barriers, onDeath);
			
		scoreLabel.text = "Score: " + Reg.score + "	    Level: " + Reg.level + "       High score: " + Reg.highScore;
		super.update();
	}	
	
	function onDeath(A:FlxBasic, B:Barrier) 
	{
		if (B.lethal) {
			/*
			 * PLAYER DEATH
			 * 
			 * 
			 * 
			 */ 
			pauseGame();
			FlxG.camera.flash();
			B.solid = false;
			player.solid = false;
			if (Reg.score > Reg.highScore)
			{
				Reg.highScore = Reg.score;
			}
			FlxG.sound.playMusic("assets/music/bu-boats-of-a-gun2.mp3");
			Reg.gameOver = true;
		}
		else {
			/*
			 * PASSED A BARRIER
			 * 
			 * 
			 * 
			 * 
			 */ 
			player.scale.set(3, 3);
			//player.
			//FlxTween.
			FlxTween.singleVar(player.scale, "x", 1, 0.3, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT } );
			FlxTween.singleVar(player.scale, "y", 1, 0.3, { ease: FlxEase.quadOut, type: FlxTween.ONESHOT } );
			Reg.score += 10;			
			FlxG.camera.flash(FlxColor.YELLOW, 0.2);
			FlxG.camera.shake(0.01, 0.2);
			B.kill();
			Reg.dodgeCount++;
			emitter.on = true;
			emitter.setPosition(player.x, player.y);
			for (i in 0...50) {
				emitter.emitParticle();
			}
			emitter.on = false;
			
			if (Reg.dodgeCount > 20)
			{
				spawning = false;
				//formationQueue.
				//Lambda.
				untyped formationQueue.length = 0;
			}
		}
	}
	
	function setSpeed(speed:Float) {
		Reg.speed = speed;
		barriers.setAll("velocity", new FlxPoint(0, speed));
	}
	
	function pauseGame() {
		barriers.setAll("velocity", new FlxPoint(0, 0));
		Reg.paused = true;
		FlxG.sound.music.pause();
		if (!Reg.gameOver)
			emitter.active = false;
		//barriers.s
	}
	function unpauseGame() {
		barriers.setAll("velocity", new FlxPoint(0, Reg.speed));
		Reg.paused = false;
		FlxG.sound.music.resume();
		emitter.active = true;
		//barriers.s
	}
	
	function restartGame() {
		unpauseGame();
		barriers.kill();
		barriers.revive();
		Reg.score = 0;
		FlxG.camera.flash();
		delay = 0.75;
		bgColor = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 0.9, 0.6);
		player.color = FlxColorUtil.HSVtoARGB(FlxRandom.floatRanged(0, 259), 1, 0.6);
		player.solid = true;
		Reg.dodgeCount = 0;
		//FlxTween.
		spawning = true;
		Reg.speed = 200;
		Reg.level = 0;
		FlxG.sound.playMusic("assets/music/bu-wings-and-goats.mp3");
		Reg.gameOver = false;
	}
	
	function addFormation() : Void {
		//var available : Array<Int> = [0, 1, 2, 3];
		//var toKill = FlxRandom.intRanged(0, 3);
		//for (i in 0...4) {			
			//
			//var bar : Barrier = recycleBarrier();
			//bar.reset(Reg.lanePositions[i] - 16, 0);
			//
			//if (i == toKill) {
				//bar.lethal = false;
				//bar.visible = false;
			//}
		//}
		
		var form : Formation = handler.getFormation();
		for (row in form.data)
		{
			formationQueue.push(row);
		}
		//formationQueue.push(form);
		
		while (formationQueue.length > 3) {
			formationQueue.shift();
		}
		
		var row : Array<Int> = formationQueue.shift();
		for (i in 0...4) {			
			var bar : Barrier = recycleBarrier();
			bar.reset(Reg.lanePositions[i] - 16, 0);
			
			if (row[i] == 0) {
				bar.lethal = false;
				bar.visible = false;
			}		
		}
		//FlxG.log.add("Removed item at " + toKill);
		//FlxG.log.add("Added a row!");
    }
	
	function recycleBarrier() : Barrier {
		var barrier:Barrier = barriers.getFirstAvailable();
		
		if (barrier == null) {
			var newBarrier:Barrier = new Barrier ();
			barriers.add(newBarrier);
			return newBarrier;
		}		
		
		return barrier;
	}
}