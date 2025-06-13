package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.InitState

class Main extends Sprite {
    public function new() {
        super();
        addChild(new FlxGame(1280, 720, InitState, 1, 60, 60, true, true));
    }
}
