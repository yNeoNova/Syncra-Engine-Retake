package utils;

import openfl.Assets;

class CoolUtil {
    public static function coolTextFile(path:String):Array<String> {
        var data:String = Assets.getText(path);
        var lines:Array<String> = data.split('\n');
        for (i in 0...lines.length) {
            lines[i] = StringTools.trim(lines[i]);
        }
        return lines.filter(l -> l != "");
    }

    public static function stringToFloatArray(data:String):Array<Float> {
        return data.split(',').map(v -> Std.parseFloat(StringTools.trim(v)));
    }

    public static function stringToIntArray(data:String):Array<Int> {
        return data.split(',').map(v -> Std.parseInt(StringTools.trim(v)));
    }
    public static function leadingZero(number:Int, digits:Int = 3):String {
        var str = Std.string(number);
        while (str.length < digits)
            str = "0" + str;
        return str;
    }
}