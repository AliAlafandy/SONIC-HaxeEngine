package asthe.backend;

import flixel.FlxState;

/** @see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/MusicBeatState.hx **/
class StateManager extends FlxState {
public var controls(get, never):Controls;
	private function get_controls() {
		return Controls.instance;
	}

	#if mobile
	public var mobileHUD:Mobile;
	public var mobileHUDCam:FlxCamera;

	public function addMobileHUD(DPad:String, Action:String):Void
	{
		if (mobileHUD != null) return;

		mobileHUD = new Mobile(DPad, Action);
		// mobileHUD.visible = true;
		add(mobileHUD);
	}

	public function addMobileHUDCam(defaultDrawTarget:Bool = false):Void
	{
		if (mobileHUD == null || mobileHUDCam != null) return;

		mobileHUDCam = createOverlayCamera(defaultDrawTarget);
		mobileHUD.cameras = [mobileHUDCam];
	}

	public function removeMobileHUD()
	{
		if (mobileHUD != null)
		{
			remove(mobileHUD);
			mobileHUD = FlxDestroyUtil.destroy(mobileHUD);
		}

		if (mobileHUDCam != null)
		{
			FlxG.cameras.remove(mobileHUDCam);
			mobileHUDCam = FlxDestroyUtil.destroy(mobileHUDCam);
		}
	}
	#end

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;

	override function create() {
		var skip:Bool = FlxTransitionableState.skipNextTransOut;

		super.create();

		if(!skip) openSubState(new CustomFadeTransition(0.5, true));
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float) {
		if (FlxG.save.data?.fullscreen != null)
			FlxG.save.data.fullscreen = FlxG.fullscreen;

		super.update(elapsed);

		/*
		if (FlxG.keys.justPressed.F5) {
			hotReload();
		} */

	}

	/* // Disabled until fix soon
	public static function hotReload():Void {
			trace("HOT RELOAD");
			Paths.clearStoredMemory();
			Paths.clearUnusedMemory();
			Locale.init();

			if (ClientPrefs.data.options.accentColors)
				SystemUtil.ACCENT_COLOR = SystemUtil.loadAccentColor();

			FlxG.resetState();
			return;
	}*/

	public static function getState():StateManager {
		return cast (FlxG.state, StateManager);
	}
}
