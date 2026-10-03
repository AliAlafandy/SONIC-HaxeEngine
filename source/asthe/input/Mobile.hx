package asthe.input;

#if mobile
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import openfl.Assets;

class Mobile extends FlxGroup
{
    public var left:Bool = false;
    public var right:Bool = false;
    public var up:Bool = false;
    public var down:Bool = false;

    public var jump:Bool = false;
    public var jumpPressed:Bool = false;

    public var pause:Bool = false;
		public var pausePressed:Bool = false;

    public var superPressed:Bool = false;
    public var superAntiPressed:Bool = false;
    public var backPressed:Bool = false;

    public var leftButton:FlxSprite;
    public var rightButton:FlxSprite;
    public var upButton:FlxSprite;
    public var downButton:FlxSprite;

    public var jumpButton:FlxSprite;
    public var pauseButton:FlxSprite;

    public var superButton:FlxSprite;
    public var superAntiButton:FlxSprite;
    public var backButton:FlxSprite;

    public var enabled:Bool = true;
    public var scaleMultiplier:Float = 1.0;
    public var edgePadding:Float = 24;
    public var dpadSpacing:Float = 4;
    private var frames:FlxAtlasFrames;

    private var previousJump:Bool = false;
    private var previousPause:Bool = false;

    public function new()
    {
        super();
        scrollFactor.set(0, 0);
        loadAtlas();
        createButtons();
        resize();
    }

    private function loadAtlas():Void
    {
        var imagePath:String = "assets/default/images/HUD/buttons/Mobile.png";
        var xmlPath:String = "assets/default/images/HUD/buttons/Mobile.xml";
        frames = FlxAtlasFrames.fromSparrow(imagePath, Assets.getText(xmlPath));
    }

    private function createButtons():Void
    {
        leftButton = createButton("dpad left0000");
        rightButton = createButton("dpad right0000");
        upButton = createButton("dpad up0000");
        downButton = createButton("dpad down0000");

        add(leftButton);
        add(rightButton);
        add(upButton);
        add(downButton);

        jumpButton = createButton("jump0000");
        add(jumpButton);

        pauseButton = createButton("pause0000");
        add(pauseButton);

        superButton = createButton("super0000");
        superAntiButton = createButton("super anti0000");
        backButton = createButton("back0000");

        add(superButton);
        add(superAntiButton);
        add(backButton);

        superButton.visible = false;
        superAntiButton.visible = false;
        backButton.visible = false;
    }

    private function createButton(frameName:String):FlxSprite
    {
        var button:FlxSprite = new FlxSprite();
        button.frames = frames;
        button.animation.addByPrefix("normal", frameName, 1, false);
        button.animation.play("normal");
        button.scrollFactor.set(0, 0);
        button.antialiasing = false;
        return button;
    }

    public function resize():Void
    {
        if (!enabled)
            return;

        var scale:Float = scaleMultiplier;
        var dpadSize:Float = 64 * scale;

        var dpadX:Float = edgePadding;
        var dpadY:Float = FlxG.height - edgePadding - dpadSize * 2;

        leftButton.setGraphicSize(Std.int(dpadSize), Std.int(dpadSize));
        rightButton.setGraphicSize(Std.int(dpadSize), Std.int(dpadSize));
        upButton.setGraphicSize(Std.int(dpadSize), Std.int(dpadSize));
        downButton.setGraphicSize(Std.int(dpadSize), Std.int(dpadSize));

        leftButton.updateHitbox();
        rightButton.updateHitbox();
        upButton.updateHitbox();
        downButton.updateHitbox();

        leftButton.setPosition(dpadX, dpadY + dpadSize);
        downButton.setPosition(dpadX + dpadSize + dpadSpacing, dpadY + dpadSize);
        rightButton.setPosition(dpadX + (dpadSize + dpadSpacing) * 2, dpadY + dpadSize);
        upButton.setPosition(dpadX + dpadSize + dpadSpacing, dpadY);

        var jumpSize:Float = 72 * scale;
        jumpButton.setGraphicSize(Std.int(jumpSize), Std.int(jumpSize));
        jumpButton.updateHitbox();
        jumpButton.setPosition(FlxG.width - edgePadding - jumpButton.width, FlxG.height - edgePadding - jumpButton.height);

        var pauseSize:Float = 40 * scale;
        pauseButton.setGraphicSize(Std.int(pauseSize), Std.int(pauseSize));
        pauseButton.updateHitbox();
        pauseButton.setPosition(FlxG.width - edgePadding - pauseButton.width, edgePadding);

        var smallSize:Float = 40 * scale;

        superButton.setGraphicSize(Std.int(smallSize), Std.int(smallSize));
        superAntiButton.setGraphicSize(Std.int(smallSize), Std.int(smallSize));
        backButton.setGraphicSize(Std.int(smallSize), Std.int(smallSize));

        superButton.updateHitbox();
        superAntiButton.updateHitbox();
        backButton.updateHitbox();

        superButton.setPosition(FlxG.width - edgePadding - smallSize, FlxG.height - edgePadding - jumpSize - smallSize - 12);
        superAntiButton.setPosition(FlxG.width - edgePadding - smallSize * 2 - 12, FlxG.height - edgePadding - jumpSize - smallSize - 12);
        backButton.setPosition(edgePadding, edgePadding);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!enabled)
        {
            resetInput();
            return;
        }

        if (FlxG.width <= 0 || FlxG.height <= 0)
            return;

        updateTouchInput();
    }

    private function updateTouchInput():Void
    {
        resetInput();

        if (FlxG.touches == null)
            return;

        for (touch in FlxG.touches.list)
        {
            var tx:Float = touch.screenX;
            var ty:Float = touch.screenY;

            if (touchInButton(tx, ty, leftButton))
                left = true;

            if (touchInButton(tx, ty, rightButton))
                right = true;

            if (touchInButton(tx, ty, upButton))
                up = true;

            if (touchInButton(tx, ty, downButton))
                down = true;

            if (touchInButton(tx, ty, jumpButton))
            {
                jump = true;

                if (touch.justPressed)
                    jumpPressed = true;
            }

            if (touchInButton(tx, ty, pauseButton))
            {
                pause = true;

                if (touch.justPressed)
                    pausePressed = true;
            }

            if (superButton.visible &&
                touchInButton(tx, ty, superButton))
            {
                if (touch.justPressed)
                    superPressed = true;
            }

            if (superAntiButton.visible &&
                touchInButton(tx, ty, superAntiButton))
            {
                if (touch.justPressed)
                    superAntiPressed = true;
            }

            if (backButton.visible &&
                touchInButton(tx, ty, backButton))
            {
                if (touch.justPressed)
                    backPressed = true;
            }
        }
    }

    private function touchInButton(touchX:Float, touchY:Float, button:FlxSprite):Bool
    {
        if (button == null || !button.visible || button.alpha <= 0)
            return false;

        return
            touchX >= button.x &&
            touchX <= button.x + button.width &&
            touchY >= button.y &&
            touchY <= button.y + button.height;
    }

    private function resetInput():Void
    {
        left = false;
        right = false;
        up = false;
        down = false;

        jump = false;
        pause = false;

        jumpPressed = false;
        pausePressed = false;

        superPressed = false;
        superAntiPressed = false;
        backPressed = false;
    }

    public function showSuperButton(value:Bool = true):Void
    {
        superButton.visible = value;
    }

    public function showSuperAntiButton(value:Bool = true):Void
    {
        superAntiButton.visible = value;
    }

    public function showBackButton(value:Bool = true):Void
    {
        backButton.visible = value;
    }

    public function setEnabled(value:Bool):Void
    {
        enabled = value;
        visible = value;

        if (!value)
            resetInput();
    }

    override public function destroy():Void
    {
        leftButton = null;
        rightButton = null;
        upButton = null;
        downButton = null;

        jumpButton = null;
        pauseButton = null;

        superButton = null;
        superAntiButton = null;
        backButton = null;

        frames = null;

        super.destroy();
    }
}
#end
