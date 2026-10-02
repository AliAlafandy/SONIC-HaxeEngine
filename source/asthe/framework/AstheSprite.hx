/*
	Sunnydev31 (@unreal.sunnydev) - Last Edition: 2026-10-01
	You are allowed to use, modify and redistribute this code
	Credit is not needed, but are appreciated.
*/

package asthe.framework;

import flixel.FlxSprite;
import flixel.addons.display.FlxSliceSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
	Custom instance for FlxSprite with better functions

	Example:
	```haxe
	var mySprite:AstheSprite = AstheSprite.create(0, 0, "My Sprite"); // calls `new AstheSprite().loadSprite(Paths.image("My Sprite"));` + `setPosition(0, 0);`
	```
**/
class AstheSprite extends FlxSprite {
	/**
		Returns the amount of frames get on Adaptive Sprite Sheet.
	**/
	public var frameCount:Int = 0;

	public function new(?x:Float = 0, ?y:Float = 0.0) {
		super(x, y);
	}

	/**
		Creates a simple sprite
		@param x Position of the sprite
		@param y Position of the sprite
		@param image The image to load
		@return AstheSprite
	**/
	public static function create(x:Float = 0, y:Float = 0, image:Null<String>):AstheSprite {
		var spr:AstheSprite = new AstheSprite(x, y).loadSprite(image);
		return spr;
	}

	/**
		Creates a sprite sheet
		@param x Position of the sprite
		@param y Position of the sprite
		@param fWidth Width per frame
		@param fHeight Height per frame
		@param image The image to load
		@return AstheSprite
	**/
	public static function createSpriteSheet(x:Float = 0, y:Float = 0, image:Null<String> = null, ?fWidth:Int, ?fHeight:Int):AstheSprite {
		return new AstheSprite(x, y).loadSpriteSheet(image, fWidth, fHeight);
	}

	/**
		Creates a sprite sheet with adaptive sizes
		@param x Position of the sprite
		@param y Position of the sprite
		@param fWidth Width per frame
		@param fHeight Height per frame
		@param image The image to load
		@return AstheSprite
	**/
	public static function createAdaptiveSpriteSheet(x:Float = 0, y:Float = 0, image:Null<String> = null):AstheSprite {
		return new AstheSprite(x, y).loadAdaptiveSpriteSheet(image);
	}

	/**
		Create a new SparrowAtlas V2 sprite.
		@param x Horizontal position.
		@param y Vertical position
		@param image Image name
		@return AstheSprite
	**/
	public static function createSparrow(x:Float = 0, y:Float = 0, image:Null<String> = null):AstheSprite {
		return new AstheSprite(x, y).loadSparrow(image);
	}

	/**
		Creates a FlxSprite gradient sprite
		@param width The width of the sprite
		@param height The height of the sprite
		@param colors The colors to create the gradient. Like: `[COLOR1, COLOR2]`...
		@param chuncks If you want a more old-skool looking chunky gradient, increase this value!
		@param angle Angle of the gradient
		@param interp Should the colors interpolate?
		@return FlxSprite
	**/
	public static function createGradient(width:Int, height:Int, ?colors:Array<FlxColor>, ?chuncks:UInt = 2, ?angle:Int = 0, ?interp:Bool = true):FlxSprite {
		// Just calls FlxGradient, lol
		var spr:FlxSprite = new FlxSprite(); // We need to use FlxSprite here because FlxGradient returns that
		spr = FlxGradient.createGradientFlxSprite(width, height, colors, chuncks, angle, interp);
		return spr;
	}

	/**
		Creates a solid shape
		@param width The width of the rectangle
		@param height The height of the rectangle
		@param color The color to fill
		@return AstheSprite
	**/
	public function createGraphic(width:Float = 1, height:Float = 1, color:FlxColor = FlxColor.WHITE):AstheSprite {
		var graph:FlxGraphic = FlxG.bitmap.create(2, 2, color, false, 'graphic($width,$height,${color.toWebString()})');
		frames = graph.imageFrame;
		scale.set(width / 2, height / 2);
		updateHitbox();
		return this;
	}

	/**
		Creates a 9-Sliced sprite!
		
		WARNING: Large graphics will stutter the game due to memory usage
		@param x Position horizontally
		@param y Vertical position
		@param width Width to final sprite
		@param height Height to final sprite
		@param image The image stored in `images/`
		@param slice Slice parameters (`[Left, Top, Spaces from Left, Spaces from Top]`)
		@param imageRect The image part you want to crop (`[X, Y, Width, Height]`)
		@return FlxSliceSprite
	**/
	public static function createSliced(x:Float, y:Float, width:Float, height:Float, image:String, slice:Array<Float>, ?imageRect:Array<Float>):FlxSliceSprite {
		// FINALLY I GOT IT HOW THIS THING WORKS -- @sunnydev31
		var sliceSprite:FlxSliceSprite = new FlxSliceSprite(Paths.image(image),
			ArrayUtil.toRect(slice), width, height,
			ArrayUtil.toRect(imageRect));
		sliceSprite.setPosition(x, y);
		return sliceSprite;
	}

	/**
	Loads a single image sprite
	@param image Sprite file name
	@return AstheSprite
	**/
	public function loadSprite(image:String):AstheSprite {
		if (StringUtil.isBlank(image)) {
			trace("'Image' argument is blank!".error());
			return this;
		}

		var graphic:FlxGraphic = Paths.image(image);

		if (graphic != null) {
			loadGraphic(graphic);
		}
		else {
			trace("Image not found! ({0})".error(), image);
		}

		return this;
	}

	/**
	Loads a Spritesheet (grid mode)
	@param image Sprite sheet file name
	@param fWidth Sprite frame width
	@param fHeight Sprite frame height
	@return AstheSprite
	**/
	public function loadSpriteSheet(image:String, fWidth:Int, fHeight:Int):AstheSprite {
		if (StringUtil.isBlank(image)) {
			trace("'Image' argument is blank!".error());
			return this;
		}

		var graphic:FlxGraphic = Paths.image(image);

		if (graphic != null) {
			loadGraphic(graphic, true, fWidth, fHeight);
		}
		else {
			trace("Image not found! ({0})".error(), image);
		}

		return this;
	}

	/**
		Loads an sprite sheet, but with an adaptive Width and Height determining the amounts of frames
		@param image The image to load
		@param vertical If the Sprite should be cropped in Vertical (Up -> Down) position and not in Horizontal (Left -> Right)
		@return AstheSprite
	**/
	public function loadAdaptiveSpriteSheet(image:String, ?vertical:Bool = false):AstheSprite {
		if (StringUtil.isBlank(image)) {
			trace("'Image' argument is blank!".error());
		}

		var graphic:FlxGraphic = Paths.image(image);

		if (graphic != null) {
			this.frameCount = (!vertical) ? Math.round(graphic.width / graphic.height) : Math.round(graphic.height / graphic.width);
			loadGraphic(graphic, true,
				(!vertical) ? Math.round(graphic.width  / frameCount) : graphic.width,
				 (vertical) ? Math.round(graphic.height / frameCount) : graphic.height);
		}
		else {
			trace("Image not found! ({0})".error(), image);
		}

		return this;
	}

	/**
		Loads an Sparrow Atlas (V2) sprite
		@param image Sprite file name
		@return AstheSprite
	**/
	public function loadSparrow(image:String):AstheSprite {
		if (StringUtil.isBlank(image)) {
			trace("'Image' argument is blank!".warn());
			return this;
		}

		var atlas = Paths.getSparrowAtlas(image);
		if (atlas != null) {
			frames = atlas;
		}
		else {
			trace('Atlas not found: {0}'.warn(), image);
		}

		return this;
	}

	private var paletteApplied:Bool = false;
	/**
		Switches global colors into custom colors, note that the sprite must
		be added or loaded to work  
		The global color is stored at `backend.Constants.PALETTE_OVERRIDE`

		@param pal The colors to replace in order, Must match the length of Constants.PALETTE_OVERRIDE
		@return AstheSprite
	**/
	public function applyPalette(pal:Array<FlxColor>):AstheSprite {
		// TODO: Add shaders support and palette system via GLSL
		if (ClientPrefs.data.options.cacheOnGPU) {
			trace("Caching sprites is enabled! Not applying palette.".warn());
			return this;
		}

		if (ArrayUtil.isBlank(pal)) {
			trace("Palette array is blank! Cannot apply this palette into sprite".error());
			return this;
		}

		if (paletteApplied) {
			trace("Palette already applied to this sprite".warn());
			return this;
		}

		if (graphic == null) {
			trace("Cannot apply palette: sprite has no valid graphic!".error());
			return this;
		}

		// Caching and checkers
		final ogSize = Constants.PALETTE_OVERRIDE.length;
		final modSize = pal.length;

		if (modSize != ogSize) {
			trace("The palette array on sprite '{0}' is not the same length as the default!".error(), this);
			return this;
		}

		try {
			for (i in 0...ogSize)
				replaceColor(Constants.PALETTE_OVERRIDE[i], pal[i]);

			paletteApplied = true;
		}
		catch (e:Dynamic) {
			trace("Something gone wrong when applying palette: {0}".error(), e);
		}

		return this;
	}

	/**
		Updates the palette even if it was already applied (for dynamic palette changes)
		@param pal The colors to replace in order
		@return AstheSprite
	**/
	public function updatePalette(pal:Array<FlxColor>):AstheSprite {
		paletteApplied = false;
		return applyPalette(pal);
	}
}
