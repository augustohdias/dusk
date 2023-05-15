package world.gen;

class WorldGen {
	private static var SIZE:Int = 1025; // A potência de 2 mais 1

	private var terrain:Array<Array<Float>> = new Array<Array<Float>>();
	private var roughness:Float = 0.6;

	public function new() {
		generateTerrain();
	}

	private function generateTerrain():Void {
		// Inicialize o terreno com zeros
		for (i in 0...SIZE) {
			var row:Array<Float> = [];
			for (j in 0...SIZE) {
				row.push(0);
			}
			terrain.push(row);
		}

		// Defina os quatro cantos para valores aleatórios
		terrain[0][0] = Math.random();
		terrain[0][SIZE - 1] = Math.random();
		terrain[SIZE - 1][0] = Math.random();
		terrain[SIZE - 1][SIZE - 1] = Math.random();

		// Execute o algoritmo Diamond-Square
		var length:Int = SIZE - 1;
		while (length > 1) {
			diamondStep(length);
			squareStep(length);
			length = Math.round(length / 2);
		}
	}

	private function diamondStep(length:Int):Void {
		var halfLength:Int = Math.floor(length / 2);
		for (x in halfLength...SIZE - 1) {
			for (y in halfLength...SIZE - 1) {
				if (x % length == halfLength && y % length == halfLength) {
					var average:Float = (terrain[x - halfLength][y - halfLength]
						+ terrain[x - halfLength][y + halfLength] + terrain[x + halfLength][y - halfLength] + terrain[x + halfLength][y + halfLength]) / 4;
					terrain[x][y] = average + Math.random() * roughness;
				}
			}
		}
	}

	private function squareStep(length:Int):Void {
		var halfLength:Int = Math.floor(length / 2);
		for (x in 0...SIZE - 1) {
			for (y in 0...SIZE - 1) {
				if (x % halfLength == 0 && y % halfLength == 0) {
					var average:Float = 0;
					var count:Int = 0;

					if (x - halfLength >= 0) {
						average += terrain[x - halfLength][y];
						count++;
					}
					if (x + halfLength < SIZE) {
						average += terrain[x + halfLength][y];
						count++;
					}
					if (y - halfLength >= 0) {
						average += terrain[x][y - halfLength];
						count++;
					}
					if (y + halfLength < SIZE) {
						average += terrain[x][y + halfLength];
						count++;
					}

					average /= count;
					terrain[x][y] = average + Math.random() * roughness;
				}
			}
		}
	}

	public function getTerrain(x:Float, y:Float):Float {
		var absX:Int = Math.floor(Math.abs(x));
		var absY:Int = Math.floor(Math.abs(y));
		return terrain[absX % SIZE][absY % SIZE];
	}

	public function isHuntArea(x:Int, y:Int):Bool {
		try {
			var terrainVal:Float = getTerrain(x, y);
			return (terrainVal > 1.3 && terrainVal < 1.5);
		} catch (e:Dynamic) {
			trace('Exception: $x, $y');
			return true;
		}
	}

	public function isTree(x:Int, y:Int):Bool {
		try {
			var absX:Int = Math.floor(Math.abs(x));
			var absY:Int = Math.floor(Math.abs(y));
			var terrainVal:Float = terrain[absX % SIZE][absY % SIZE];
			return (terrainVal > 1 && terrainVal < 1.2);
		} catch (e:Dynamic) {
			trace('Exception: $x, $y');
			return true;
		}
	}
}
