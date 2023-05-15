package battle;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIBar;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIText;
import flixel.util.FlxColor;
import haxe.xml.Access;
import openfl.Assets;
import world.Constants;
import world.entity.Player;
import world.entity.soul.Soul;

class Battle extends FlxSubState {
	private final posicoesCursor:Array<Float> = [16, 66, 116, 166];

	private var currentCursorIndex:Int = 0;

	private var battleCamera:FlxCamera;
	var enemy:Soul;
	var playerParty:List<Soul>;

	var ui:FlxUI;
	var cursor:FlxSprite;

	public function new(player:Player) {
		super();
		playerParty = player.getPlayerParty();
		enemy = new Soul();
	}

	override public function create():Void {
		super.create();
		if (FlxG.camera != battleCamera) {
			battleCamera = new FlxCamera(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
			FlxG.cameras.reset(battleCamera);
		}

		setupBackground();

		loadUI();
		setupBattleMenu();
		setupCards();
	}

	function setupCards() {
		if (ui != null) {
			final enemyClass:FlxUIText = cast ui.getAsset("enemy_class"), FlxUIText;
			enemyClass.text = enemy.getSoulClass();
			final enemyClass:FlxUIText = cast ui.getAsset("enemy_level"), FlxUIText;
			enemyClass.text = 'Lv.${enemy.getLevel()}';
			final enemyHP:FlxUIBar = cast ui.getAsset("enemy_hp"), FlxUIBar;
			enemyHP.setParent(enemy, "healthPercentage");
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (enemy.getHealth() < 0) {
			close();
		}
		if (FlxG.keys.justPressed.LEFT) {
			moveCursor(-1);
		} else if (FlxG.keys.justPressed.RIGHT) {
			moveCursor(1);
		}
	}

	function moveCursor(delta:Int):Void {
		// Calcula a nova posição do cursor
		currentCursorIndex += delta;
		if (currentCursorIndex < 0) {
			currentCursorIndex = 0;
		}
		if (currentCursorIndex > 3) {
			currentCursorIndex = 3;
		}
		cursor.x = posicoesCursor[currentCursorIndex];
	}

	private function setupBackground() {
		var background:FlxSprite = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(background);
	}

	private function setupBattleMenu() {
		setupButtons();
		setupCursor();
	}

	function loadUI() {
		ui = new FlxUI();
		var xmlText:String = Assets.getText(AssetPaths.ui__xml);
		var xml:Xml = Xml.parse(xmlText).firstElement();
		var access:Access = new Access(xml);
		ui.load(access);
		add(ui);
	}

	function setupCursor() {
		cursor = new FlxSprite(16, FlxG.height - 50);
		cursor.loadGraphic(AssetPaths.cursor__png, true, Constants.TILE_SIZE, Constants.TILE_SIZE);
		cursor.angle = 90;
		cursor.animation.add("idle", [0, 1, 3, 2], 4, true);
		cursor.animation.play("idle");
		add(cursor);
	}

	function setupButtons():Void {
		if (ui != null) {
			final atacar = cast ui.getAsset("btn_atacar"), FlxUIButton;
			final mochila = cast ui.getAsset("btn_mochila"), FlxUIButton;
			final correr = cast ui.getAsset("btn_correr"), FlxUIButton;
			final trocar = cast ui.getAsset("btn_trocar"), FlxUIButton;

			final moveMenu = ui.getGroup("move_menu");
			moveMenu.visible = false;
			for (index in 0...moveMenu.members.length) {
				var button:FlxUIButton = cast moveMenu.members[index];
				var moveset = playerParty.first().getMoveSet();
				if (index < moveset.length) {
					var move = moveset[index];
					button.label.text = '${move.getName()}';
					button.onUp.callback = function() {
						attack(move);
						final moveMenu = ui.getGroup("move_menu");
						moveMenu.visible = false;
						final battleMenu = ui.getGroup("menu_inferior");
						battleMenu.visible = true;
					}
				}
			}

			atacar.onUp.callback = changeToMoveMenu;
			mochila.onUp.callback = bag;
			correr.onUp.callback = run;
			trocar.onUp.callback = bag;
		}
	}

	private function changeToMoveMenu() {
		final moveMenu = ui.getGroup("move_menu");
		moveMenu.visible = true;
		final battleMenu = ui.getGroup("menu_inferior");
		battleMenu.visible = false;
	}

	private function attack(move:Move) {
		playerParty.first().attack(enemy, move, this);
	}

	private function run() {
		close();
	}

	private function bag() {
		trace('bag');
	}
}
