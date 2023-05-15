package;

import flixel.FlxGame;
import openfl.display.Sprite;
import world.Constants;
import world.World;

class Main extends Sprite {
	public function new() {
		super();
		addChild(new FlxGame(Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT, World));
	}
}
