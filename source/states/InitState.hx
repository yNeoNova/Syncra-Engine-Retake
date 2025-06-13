package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.utils.Assets;
import openfl.filesystem.File;
import openfl.filesystem.FileMode;
import openfl.filesystem.FileStream;

class InitState extends FlxState {
    var dirPath:String = "/storage/emulated/0/.Syncra Engine";
    var assetsPath:String;
    var modsPath:String;

    override public function create():Void {
        super.create();

        assetsPath = '$dirPath/assets';
        modsPath = '$dirPath/mods';

        showWarningPopup();
    }

    function showWarningPopup():Void {
        FlxG.camera.bgColor = FlxColor.BLACK;

        var warning:FlxText = new FlxText(0, 100, FlxG.width, "WARNING! MISSING FILES");
        warning.setFormat(null, 24, FlxColor.RED, "center");
        add(warning);

        var message:FlxText = new FlxText(0, 140, FlxG.width, 
            'It seems it\'s missing some files to run the game.\nPlease press OK to copy the needed files.'
        );
        message.setFormat(null, 16, FlxColor.WHITE, "center");
        add(message);

        var okButton:FlxButton = new FlxButton(FlxG.width / 2 - 40, 220, "OK", copyFilesAndContinue);
        okButton.color = FlxColor.GRAY;
        okButton.label.color = FlxColor.WHITE;
        add(okButton);
    }

    function copyFilesAndContinue():Void {
        createDirectoryIfMissing(dirPath);
        createDirectoryIfMissing(assetsPath);
        createDirectoryIfMissing(modsPath);
      
        FlxG.switchState(new TitleState());
    }

    function createDirectoryIfMissing(path:String):Void {
        var dir = new File(path);
        if (!dir.exists) {
            dir.createDirectory();
        }
    }
}
