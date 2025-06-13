package;

import openfl.utils.Assets;

class Paths {
    public static var currentMod:String = '';

    public static function getPath(key:String, ?folder:String = ""):String {
        return folder != "" ? '$folder/$key' : key;
    }
    public static function txt(key:String):String {
        return 'assets/data/$key.txt';
    }
    public static function image(key:String):String {
        return 'assets/images/$key.png';
    }
    public static function xml(key:String):String {
        return 'assets/images/$key.xml';
    }
    public static function sound(key:String):String {
        return 'assets/sounds/$key.ogg';
    }

    public static function music(key:String):String {
        return 'assets/music/$key.ogg';
    }

    public static function modTxt(key:String):String {
        if (currentMod != '') return 'mods/$currentMod/data/$key.txt';
        return txt(key);
    }

    public static function exists(path:String):Bool {
        return Assets.exists(path);
    }
}
