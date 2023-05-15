package battle;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import world.entity.Player;
import world.entity.soul.Soul;

class Battle extends FlxSubState {
	private var battleCamera:FlxCamera;
	private var enemy:Soul = new Soul();
	private var playerParty:List<Soul>;
	private var fightMenu = new FlxGroup();
	private var moveSetMenu = new FlxGroup();

	public function new(player:Player) {
		super();
		playerParty = player.getPlayerParty();
	}

	override public function create():Void {
		super.create();
		if (FlxG.camera != battleCamera) {
			battleCamera = new FlxCamera(0, 0, 640, 480);
			FlxG.cameras.reset(battleCamera);
		}
		var background:FlxSprite = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, 0xff078c00); // Preto
		add(background);

		var playerSprite:FlxSprite = new FlxSprite(FlxG.width / 4, FlxG.height / 2);
		playerSprite.makeGraphic(32, 32, 0xff0000ff); // Azul
		add(playerSprite);

		var enemySprite:FlxSprite = new FlxSprite((FlxG.width * 3 / 4), FlxG.height / 4);
		enemySprite.makeGraphic(32, 32, enemy.getColor()); // Vermelho
		add(enemySprite);

		createFightMenu();
		createMoveMenu();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (enemy.getHealth() < 0) {
			trace('Enemy fainted.');
			close();
		}
	}

	private function createFightMenu() {
		var fightButton:FlxButton = new FlxButton(FlxG.width / 4, FlxG.height - 30, "Attack", pullMoveSetMenu);
		fightMenu.add(fightButton);
		var bagButton:FlxButton = new FlxButton(FlxG.width / 2, FlxG.height - 30, "Bag", bag);
		fightMenu.add(bagButton);
		var runButton:FlxButton = new FlxButton(FlxG.width * 3 / 4, FlxG.height - 30, "Run", run);
		fightMenu.add(runButton);
		add(fightMenu);
	}

	private function createMoveMenu() {
		final moveSet = playerParty.first().getMoveSet();
		for (i in 0...moveSet.length) {
			var button = new FlxButton(FlxG.width / (4 / i + 1), FlxG.height - 30, moveSet[i].getName(), function() {
				attack(moveSet[i]);
			});
			moveSetMenu.add(button);
		}
	}

	private function attack(move:Move) {
		playerParty.first().attack(enemy, move, this);
		remove(moveSetMenu, false);
		add(fightMenu);
	}

	private function pullMoveSetMenu() {
		remove(fightMenu, false);
		add(moveSetMenu);
	}

	private function run() {
		close();
	}

	private function bag() {
		trace('bag');
	}
}
