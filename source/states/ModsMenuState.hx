package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.animation.FlxAtlasFrames;
import flixel.math.FlxMath;
import openfl.filters.ShaderFilter;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;

using StringTools;

typedef ModInfo = {
    var modName:String;
    var modDescripition:String;
    var iconIsAnimated:Bool;
}

class ModsMenuState extends FlxState
{
    var mods:Array<{info:ModInfo, folder:String}> = [];
    var modTexts:Array<FlxText> = [];
    var icons:Array<FlxSprite> = [];
    var selectedIndex:Int = 0;

    var descText:FlxText;
    var vcrFont:String = "VCR";

    var bg:FlxSprite;
    var gridOverlay:FlxSprite;

    var rgbColor:FlxColor = FlxColor.WHITE;
    var targetColor:FlxColor = FlxColor.WHITE;
    var colorTransitionSpeed:Float = 0.5;
    var colorChangeTimer:Float = 0;

    override public function create():Void
    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
        bg.scrollFactor.set();
        add(bg);

        gridOverlay = FlxGridOverlay.create(40, 40, FlxG.width, FlxG.height);
        gridOverlay.scrollFactor.set();
        gridOverlay.alpha = 0.3;
        add(gridOverlay);

        loadMods();

        for (i in 0...mods.length)
        {
            var modText = new FlxText(100, 100 + (i * 70), 0, mods[i].info.modName);
            modText.setFormat(vcrFont, 32, FlxColor.WHITE, "left");
            add(modText);
            modTexts.push(modText);

            var iconPath = 'mods/' + mods[i].folder + '/Mod-Icon.png';
            var icon = new FlxSprite(30, modText.y);
            if (mods[i].info.iconIsAnimated)
            {
                icon.frames = FlxAtlasFrames.fromSparrow(
                    Paths.image('mods/' + mods[i].folder + '/Mod-Icon'),
                    Paths.txt('mods/' + mods[i].folder + '/Mod-Icon.xml')
                );
                icon.animation.addByPrefix("idle", "iconAnim", 24, true);
                icon.animation.play("idle");
            }
            else
            {
                icon.loadGraphic(iconPath);
            }
            icon.setGraphicSize(48, 48);
            icon.updateHitbox();
            add(icon);
            icons.push(icon);
        }

        descText = new FlxText(500, 100, 400, "");
        descText.setFormat(vcrFont, 20, FlxColor.WHITE, "left");
        add(descText);

        updateHighlight();
        generateNewTargetColor();
    }

    function loadMods():Void
    {
        var modsFolder = "mods/";

        for (folder in FileSystem.readDirectory(modsFolder))
        {
            var path = modsFolder + folder + "/Mod-Info.json";
            if (FileSystem.exists(path))
            {
                try
                {
                    var rawData = File.getContent(path);
                    var json:ModInfo = Json.parse(rawData);
                    mods.push({info: json, folder: folder});
                }
                catch (e)
                {
                    trace('Error loading mod info from ' + path + ': ' + e);
                }
            }
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        colorChangeTimer += elapsed * colorTransitionSpeed;
        if (colorChangeTimer >= 1)
        {
            rgbColor = targetColor;
            generateNewTargetColor();
            colorChangeTimer = 0;
        }

        var lerpR = FlxMath.lerp(FlxColor.red(rgbColor), FlxColor.red(targetColor), colorChangeTimer);
        var lerpG = FlxMath.lerp(FlxColor.green(rgbColor), FlxColor.green(targetColor), colorChangeTimer);
        var lerpB = FlxMath.lerp(FlxColor.blue(rgbColor), FlxColor.blue(targetColor), colorChangeTimer);
        var lerpedColor = FlxColor.fromRGB(Math.floor(lerpR), Math.floor(lerpG), Math.floor(lerpB));

        bg.color = lerpedColor;
        gridOverlay.color = invertColor(lerpedColor);

        if (FlxG.keys.justPressed.UP)
        {
            selectedIndex = (selectedIndex - 1 + mods.length) % mods.length;
            updateHighlight();
        }

        if (FlxG.keys.justPressed.DOWN)
        {
            selectedIndex = (selectedIndex + 1) % mods.length;
            updateHighlight();
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            FlxG.switchState(new MainMenuState());
        }
    }

    function updateHighlight():Void
    {
        for (i in 0...modTexts.length)
        {
            modTexts[i].setFormat(vcrFont, 32, (i == selectedIndex) ? FlxColor.YELLOW : FlxColor.WHITE, "left");
        }

        descText.text = mods[selectedIndex].info.modDescripition;
    }

    function generateNewTargetColor():Void
    {
        targetColor = FlxColor.fromRGB(
            FlxG.random.int(50, 255),
            FlxG.random.int(50, 255),
            FlxG.random.int(50, 255)
        );
    }

    function invertColor(color:FlxColor):FlxColor
    {
        return FlxColor.fromRGB(
            255 - FlxColor.red(color),
            255 - FlxColor.green(color),
            255 - FlxColor.blue(color)
        );
    }
}