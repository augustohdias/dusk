package world;

import battle.Battle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.graphics.atlas.FlxAtlas;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;

class World extends FlxState {
	final tileSize:Int = 16;
	final moveCooldown:Float = 0.2;
	final tiledMap:TiledMap = new TiledMap("assets/data/map.tmx");

	var player:FlxSprite;
	var timeSinceLastMove:Float = 0;
	var currentBattle:Battle;
	var worldCamera:FlxCamera;
	var playerGroup:FlxGroup = new FlxGroup();
	var mapGroup:FlxGroup = new FlxGroup();

	public function loadMap():Void {
		for (tileLayer in tiledMap.layers) {
			var tilesets = tileLayer.map.tilesets;
			for (tileset in tilesets) {
				var map = new FlxTilemap();
				var tl:TiledTileLayer = cast tileLayer;
				var path = StringTools.replace(tileset.imageSource, "..", "assets");
				trace('${tileLayer.name}:${tileset.name}:${path}');
				map.loadMapFromCSV(tl.csvData, path, tileSize, tileSize, OFF, 1);
				mapGroup.add(map);
			}
		}
	}

	override public function create():Void {
		super.create();
		loadMap();
		loadPlayer();
	}

	private function loadPlayer() {
		player = new FlxSprite(0, 0);
		var atlas = new FlxAtlas("playerAtlas");

		for (i in 0...25) {
			var fileName:String = "assets/images/FRAMES/chara/chara2_5/" + i + ".png";
			atlas.addNode(fileName, "frame" + i);
		}

		player.frames = atlas.getAtlasFrames();

		player.animation.add('wdown', [1, 0, 2, 0], 4, false);
		player.animation.add('wleft', [4, 3, 5, 3], 4, false);
		player.animation.add('wright', [7, 6, 8, 6], 4, false);
		player.animation.add('wup', [10, 9, 11, 9], 4, false);
		player.facing = DOWN;
		playerGroup.add(player);
	}

	private function spawnBattle() {
		var playerTileX:Int = Math.floor(player.x / tileSize);
		var playerTileY:Int = Math.floor(player.y / tileSize);
		var type = getTileType(playerTileX, playerTileY + 1);
		var factor = Math.random();
		trace('$type');
		if (type == "HuntArea" && factor < 0.05) {
			player.animation.stop();
			openSubState(new Battle());
		}
	}

	private function getTileType(x:Int, y:Int):String {
		var tileLayer:TiledTileLayer = cast tiledMap.layers[0];
		var tileId:Int = tileLayer.tileArray[x + (y) * (tileLayer.width)];
		trace('idx:${x + y * 30}');
		trace('TileId: ${tileId}');
		var tileset:TiledTileSet = tiledMap.getGidOwner(tileId);
		return tileset.tileTypes[tileId - 1];
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		add(mapGroup);
		add(playerGroup);
		if (FlxG.camera != worldCamera) {
			worldCamera = new FlxCamera(0, 0, 640, 480);
			worldCamera.follow(player);
			FlxG.cameras.reset(worldCamera);
		}

		handleMovement(elapsed);
		updatePlayer();
	}

	private function updatePlayer():Void {
		if (player != null) {
			remove(player, false);
			add(player);
		}
		var strategy:Map<FlxDirectionFlags, Void->Void> = new Map();
		strategy.set(DOWN, walkDown);
		strategy.set(LEFT, walkLeft);
		strategy.set(RIGHT, walkRight);
		strategy.set(UP, walkUp);
	}

	function walkDown() {
		player.animation.play('wdown');
	}

	function walkUp() {
		player.animation.play('wup');
	}

	function walkLeft() {
		player.animation.play('wleft');
	}

	function walkRight() {
		player.animation.play('wright');
	}

	private function handleMovement(elapsed:Float) {
		var px = Math.floor(player.x / tileSize);
		var py = Math.floor(player.y / tileSize);
		timeSinceLastMove += elapsed;

		if (timeSinceLastMove > moveCooldown) {
			if (FlxG.keys.pressed.LEFT) {
				player.animation.play('wleft');

				player.x -= tileSize;
				player.facing = LEFT;
				spawnBattle();
			}
			if (FlxG.keys.pressed.RIGHT) {
				player.animation.play('wright');

				player.x += tileSize;
				player.facing = RIGHT;
				spawnBattle();
			}
			if (FlxG.keys.pressed.UP) {
				player.animation.play('wup');

				player.y -= tileSize;
				player.facing = UP;
				spawnBattle();
			}
			if (FlxG.keys.pressed.DOWN) {
				player.animation.play('wdown');

				player.y += tileSize;
				player.facing = DOWN;
				spawnBattle();
			}
			timeSinceLastMove -= moveCooldown;
		}
	}
}
