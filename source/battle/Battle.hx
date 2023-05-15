package battle;

import flixel.FlxCamera;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class Battle extends FlxSubState
{
	var battleCamera:FlxCamera;

	override public function create():Void
	{
		super.create();
		if (FlxG.camera != battleCamera)
		{
			battleCamera = new FlxCamera(0, 0, 640, 480);
			FlxG.cameras.reset(battleCamera);
		}
		// Fundo da batalha
		var background:FlxSprite = new FlxSprite(0, 0);
		background.makeGraphic(FlxG.width, FlxG.height, 0xff000000); // Preto
		add(background);

		// Sprite do jogador e do inimigo
		var playerSprite:FlxSprite = new FlxSprite(FlxG.width / 4, FlxG.height / 2);
		playerSprite.makeGraphic(32, 32, 0xff0000ff); // Azul
		add(playerSprite);
		var enemySprite:FlxSprite = new FlxSprite((FlxG.width * 3 / 4), FlxG.height / 4);
		enemySprite.makeGraphic(32, 32, 0xffff0000); // Vermelho
		add(enemySprite);

		// Botões do menu
		var fightButton:FlxButton = new FlxButton(FlxG.width / 4, FlxG.height - 30, "Fight", function() trace("Fight selected"));
		add(fightButton);

		var bagButton:FlxButton = new FlxButton(FlxG.width / 2, FlxG.height - 30, "Bag", function() trace("Bag selected"));
		add(bagButton);

		var runButton:FlxButton = new FlxButton(FlxG.width * 3 / 4, FlxG.height - 30, "Run", function()
		{
			close();
		});
		add(runButton);
	}
}
