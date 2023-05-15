package world.map;

import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledMap;

class Map {
    private final tiledMap:TiledMap;

    public function new(path:String) {
		this.tiledMap = new TiledMap(path);
    }

	public function getTileType(x:Int, y:Int):String {
		var tileLayer:TiledTileLayer = cast tiledMap.layers[0];
		var tileId:Int = tileLayer.tileArray[x + (y * tileLayer.width)];
		var tileset:TiledTileSet = tiledMap.getGidOwner(tileId);
		return tileset.tileTypes[tileId - 1];
	}

    public function getTiledMap():TiledMap {
        return tiledMap;
    }
}
