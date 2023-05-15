package world.entity;

import flixel.graphics.atlas.FlxAtlas;
import flixel.FlxG;
import flixel.FlxSprite;
import world.entity.soul.Soul;

class Player {

    private var playerSprite:FlxSprite;
	private var party:List<Soul>;
    private var timeSinceLastMove:Float = 0;
    private var moveOnCooldown:Bool = false;

    public function new() {
		playerSprite = new FlxSprite(0, 0);
		var atlas = new FlxAtlas("playerAtlas");

		for (i in 0...25) {
			var fileName:String = "assets/images/FRAMES/chara/chara2_5/" + i + ".png";
			atlas.addNode(fileName, "frame" + i);
		}
		party.add(new Soul());
		playerSprite.frames = atlas.getAtlasFrames();
		playerSprite.animation.add('wdown', [1, 0, 2, 0], 4, false);
		playerSprite.animation.add('wleft', [4, 3, 5, 3], 4, false);
		playerSprite.animation.add('wright', [7, 6, 8, 6], 4, false);
		playerSprite.animation.add('wup', [10, 9, 11, 9], 4, false);
		playerSprite.facing = DOWN;
    }

    public function update(elapsed:Float) {
		timeSinceLastMove += elapsed;

		if (timeSinceLastMove > Constants.MOVE_COOLDOWN) {
			moveOnCooldown = false;
            if (FlxG.keys.pressed.LEFT) {
				playerSprite.animation.play('wleft');
				playerSprite.x -= Constants.TILE_SIZE;
				playerSprite.facing = LEFT;
				moveOnCooldown = true;
			} else if (FlxG.keys.pressed.RIGHT) {
				playerSprite.animation.play('wright');
				playerSprite.x += Constants.TILE_SIZE;
				playerSprite.facing = RIGHT;
				moveOnCooldown = true;
			} else if (FlxG.keys.pressed.UP) {
				playerSprite.animation.play('wup');
				playerSprite.y -= Constants.TILE_SIZE;
				playerSprite.facing = UP;
				moveOnCooldown = true;
			} else if (FlxG.keys.pressed.DOWN) {
				playerSprite.animation.play('wdown');
				playerSprite.y += Constants.TILE_SIZE;
				playerSprite.facing = DOWN;
				moveOnCooldown = true;
			}
			timeSinceLastMove -= Constants.MOVE_COOLDOWN;
		}
    }

    public function isMoveOnCooldown():Bool {
        return moveOnCooldown;
    }

    public function stop() {
        playerSprite.animation.stop();
    }

    public function getPlayerSprite():FlxSprite {
        return playerSprite;
    }

	public function getPlayerParty():List<Soul> {
		return party;
	}

    public function getX():Int {
        return Math.round(playerSprite.x/Constants.TILE_SIZE);
    }

	public function getY():Int {
		return Math.round(playerSprite.y / Constants.TILE_SIZE) + 1;
    }
}