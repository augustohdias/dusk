package world.entity.soul;

import flixel.util.FlxColor;
import battle.Move;
import battle.Battle;

class Soul {
	var level:Int;
	var soulClass:SoulClass;
	var soulElement:SoulElement;
	var moveSet:List<Move>;

	var physicalPower:Int = 1;
	var magicalPower:Int = 1;
	var speed:Int = 1;
	var health:Float = 10;
	var physicalDefense:Int = 1;
	var magicalDefense:Int = 1;
	var totalExperience:Int = 1;
	var energy:Int = 1;
	var sprite:FlxColor;

	public function new() {
		level = Math.floor(Math.random() * 10);
		var soulClasses = SoulClass.createAll();
		var soulElements = SoulElement.createAll();
		soulClass = soulClasses[Math.floor(Math.random() * soulClasses.length)];
		soulElement = soulElements[Math.floor(Math.random() * soulElements.length)];
		sprite = switch (soulElement) {
			case FIRE: 0xffff0000;
			case WATER: 0xff0800a4;
			case ELECTRIC: 0xffffdc2e;
			case LIGHT: 0xffd6ff6d;
			case DARK: 0xff480026;
		}
		moveSet = new List<Move>();
		moveSet.add(Move.Punch);
		moveSet.add(Move.Blast);
	}

	public function getColor():FlxColor {
		return sprite;
	}

	public function attack(target:Soul, move:Move, environment:Battle) {
		// Apply move effects on environment, player, target
		var damage = switch (move.type) {
			case PHYSICAL:
				(move.power / 100) * physicalPower;
			case MAGICAL:
				(move.power / 100) * magicalPower;
		}
		trace('${this.soulClass} dealt $damage to ${target.soulClass}.');
		target.health -= damage;
	}

	public function getMoveSet():Array<Move> {
		var resp = new Array<Move>();
		for (move in moveSet) {
			resp.insert(resp.length, move);
		}
		return resp;
	}
}
