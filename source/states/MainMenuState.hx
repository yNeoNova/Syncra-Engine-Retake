package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.FlxCamera;

import utils.Paths;
import utils.CoolUtil;

class MainMenuState extends FlxState
{
	private var options:Array<String> = ["story", "freeplay", "credits", "options"];
	private var optionSprites:FlxTypedGroup<FlxSprite>;
	private var curSelected:Int = 0;

	override public function create():Void
	{
		super.create();

		var bg = new FlxSprite().loadGraphic(Paths.image("mainmenu/background/menuBG"));
		bg.screenCenter();
		add(bg);

		optionSprites = new FlxTypedGroup<FlxSprite>();
		add(optionSprites);

		for (i in 0...options.length)
		{
			var spr = new FlxSprite(0, 150 + (i * 130));
			spr.frames = Paths.getSparrowAtlas("mainmenu/" + options[i]);
			spr.animation.addByPrefix("idle", options[i] + " basic", 24, true);
			spr.animation.addByPrefix("selected", options[i] + " white", 24, true);
			spr.animation.play("idle");
			spr.screenCenter(X);
			optionSprites.add(spr);
		}

		changeSelection(0);

		FlxG.camera.fade(FlxColor.BLACK, 0, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.UP) changeSelection(-1);
		if (FlxG.keys.justPressed.DOWN) changeSelection(1);

		if (FlxG.keys.justPressed.ENTER)
		{
			selectOption();
		}

		if (FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.play(Paths.sound("cancelMenu"));
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
				FlxG.switchState(new TitleState());
			});
		}

		if (FlxG.keys.justPressed.M)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
				FlxG.switchState(new ModsMenuState());
			});
		}
	}

	private function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (change != 0)
			FlxG.sound.play(Paths.sound("scrollMenu"));

		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		for (i in 0...optionSprites.length)
		{
			var spr = optionSprites.members[i];
			if (i == curSelected)
				spr.animation.play("selected");
			else
				spr.animation.play("idle");
		}
	}

	private function selectOption():Void
	{
		FlxG.sound.play(Paths.sound("confirmMenu"));

		switch (curSelected)
		{
			case 0: // Story Mode
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
					FlxG.switchState(new StoryMenuState());
				});
			case 1: // Freeplay
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
					FlxG.switchState(new FreeplayState());
				});
			case 2: // Credits
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
					FlxG.switchState(new CreditsState());
				});
			case 3: // Options
				FlxG.camera.fade(FlxColor.BLACK, 0.5, false, () -> {
					FlxG.switchState(new OptionsState());
				});
		}
	}
}