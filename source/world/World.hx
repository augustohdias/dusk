package world;

import battle.Battle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import world.entity.Player;
import world.map.Map;

class World extends FlxState {
	private final playerGroup:FlxGroup = new FlxGroup();
	private final mapGroup:FlxGroup = new FlxGroup();

	private var player:Player;
	private var map:Map;

	var worldCamera:FlxCamera;

	override public function create():Void {
		super.create();
		loadMap();
		loadPlayer();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		add(mapGroup);
		add(playerGroup);
		if (FlxG.camera != worldCamera) {
			worldCamera = new FlxCamera(0, 0, Constants.SCREEN_WIDTH, Constants.SCREEN_HEIGHT);
			worldCamera.follow(player.getPlayerSprite());
			FlxG.cameras.reset(worldCamera);
		}
		player.update(elapsed);
		if (shouldSpawnBattle(elapsed)) {
			player.stop();
			openSubState(new Battle(player));
		}
	}

	private function loadPlayer() {
		player = new Player();
		playerGroup.add(player.getPlayerSprite());
	}

	public function loadMap():Void {
		map = new Map("assets/data/map.tmx");
		var tiledMap = map.getTiledMap();
		for (tileLayer in tiledMap.layers) {
			var tilesets = tileLayer.map.tilesets;
			for (tileset in tilesets) {
				var map = new FlxTilemap();
				var tl:TiledTileLayer = cast tileLayer;
				var path = StringTools.replace(tileset.imageSource, "..", "assets");
				map.loadMapFromCSV(tl.csvData, path, Constants.TILE_SIZE, Constants.TILE_SIZE, OFF, 1);
				mapGroup.add(map);
			}
		}
	}

	private function shouldSpawnBattle(elapsed:Float) {
		var type = map.getTileType(player.getX(), player.getY());
		var factor = Math.random();
		if (player.isMoveOnCooldown() && FlxG.keys.anyPressed([LEFT, UP, RIGHT, DOWN]) && type == "HuntArea" && factor < 0.005) {
			return true;
		}
		return false;
	}
}
