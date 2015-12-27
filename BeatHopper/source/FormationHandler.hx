package;
import flixel.FlxG;
import flixel.util.FlxRandom;
import haxe.Json;
import openfl.Assets;

/**
 * ...
 * @author Noogai03
 */
class FormationHandler
{
	var data : Array<Formation>;
	public function new() 
	{
		data = new Array<Formation>();
	}
	public function loadFormations() {
		var json : String = Assets.getText("assets/data/formations.json");
		data = Json.parse(json);
	}
	public function logFormations() {
		//data.push( { data:[[1, 1, 1, 0], [1, 1, 0, 1], [1, 0, 1, 1], [0, 1, 1, 1]], height:4 } );
		//data.push( { data:[[1, 0, 1, 0], [0, 1, 0, 1], [1, 0, 1, 0], [0, 1, 0, 1]], height:4 } );
		//FlxG.log.add(Json.stringify(data));
		FlxG.log.add(data);
		
		//var lol:Formation = { data : [[]], height:2 };
		
	}
	
	public function getFormation() : Formation {
		//FlxRandom
		return data[FlxRandom.intRanged(0, data.length - 1)];
	}
	
}

typedef Formation = {
	data : Array<Array<Int>>,
	height : Int
}