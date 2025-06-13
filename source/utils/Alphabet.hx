package utils;

import flixel.FlxSprite;
import flixel.addons.graphics.FlxAtlasFrames;
import openfl.utils.Assets;

class Alphabet {
    public var sprite:FlxSprite;

    public function new() {
        sprite = new FlxSprite();
        var atlas = FlxAtlasFrames.fromTexturePackerXml(
            Assets.getBitmapData("assets/images/menus/alphabet.png"),
            Assets.getText("assets/images/menus/alphabet.xml")
        );
        sprite.set_frames(atlas);
    }

    public function createChar(char:String):FlxSprite {
        var s = new FlxSprite();
        s.set_frames(sprite.frames);
        if (s.frames != null && s.frames.getAnimation(char) != null) {
            s.animation.play(char, true);
        } else {
            s.frame = 0;
        }
        return s;
    }

    public function createText(text:String):Array<FlxSprite> {
        var chars = new Array<FlxSprite>();
        for (c in text.toUpperCase()) {
            chars.push(createChar(c));
        }
        return chars;
    }
}