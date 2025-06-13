package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import openfl.utils.Assets;
import utils.CoolUtil;

class TitleState extends FlxState {
    var logo:FlxSprite;
    var gf:FlxSprite;
    var enter:FlxSprite;
    var introMessages:Array<String>;
    var messageText:FlxText;
    var curIntroMsg:Int = 0;
    var finishedIntro:Bool = false;

    override public function create():Void {
        super.create();

        FlxG.sound.playMusic(Paths.music('freakyMenu'));

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        var ngLogo = new FlxSprite(FlxG.width/2 - 300, FlxG.height/2 - 200, Paths.image('newgrounds_logo'));
        add(ngLogo);

        var ngText = new FlxText(0, ngLogo.y + ngLogo.height + 20, FlxG.width, "Not associated with Newgrounds").setFormat(null, 24, 0xFFFFFFFF, CENTER);
        add(ngText);

        new FlxTimer().start(4, (_) -> {
            ngLogo.visible = ngText.visible = false;
            showCredits();
        });
    }

    function showCredits():Void {
        messageText = new FlxText(0, FlxG.height / 2 - 100, FlxG.width, "Friday Night Funkin' By").setFormat(null, 32, 0xFFFFFFFF, CENTER);
        add(messageText);

        new FlxTimer().start(4, (_) -> {
            messageText.text = "ninjamuffin99\nphantomArcade\nkawaisprite\nand\nevilsk8er";
            new FlxTimer().start(4, (_) -> {
                introMessages = CoolUtil.coolTextFile(Paths.txt('introMessages'));
                curIntroMsg = 0;
                nextIntroMsg();
            });
        });
    }

    function nextIntroMsg():Void {
        if (curIntroMsg >= introMessages.length) {
            FlxG.camera.flash(0xFFFFFFFF, 1, () -> showTitle());
            return;
        }

        messageText.text = introMessages[curIntroMsg++];
        new FlxTimer().start(2, (_) -> nextIntroMsg());
    }

    function showTitle():Void {
        finishedIntro = true;
        messageText.visible = false;

        gf = new FlxSprite(0, FlxG.height - 400);
        gf.frames = Paths.getPath('gfDancin.xml', 'assets/images');
        gf.animation.addByPrefix('dance', 'gfDance', 24, true);
        gf.animation.play('dance');
        add(gf);

        logo = new FlxSprite(FlxG.width/2 - 400, 50);
        logo.frames = Paths.getPath('logo.xml', 'assets/images');
        logo.animation.addByPrefix('bump', 'logo bumpin', 24, true);
        logo.animation.play('bump');
        add(logo);

        enter = new FlxSprite(FlxG.width/2 - 400, FlxG.height - 150);
        enter.frames = Paths.getPath('titleEnter.xml', 'assets/images');
        enter.animation.addByPrefix('idle', 'ENTER IDLE', 12, true);
        enter.animation.addByPrefix('pressed', 'ENTER PRESSED', 12, false);
        enter.animation.play('idle');
        add(enter);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (finishedIntro && FlxG.keys.justPressed.ENTER) {
            enter.animation.play('pressed', true);
            FlxG.camera.fade(FlxColor.BLACK, 1, false, () -> {
                FlxG.switchState(new MainMenuState());
            });
        }
    }
}