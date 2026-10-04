package asthe.backend;

import flixel.FlxSubState;

/**
	@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/MusicBeatSubstate.hx
**/
class SubStateManager extends FlxSubState {
	public function new() super();

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return Controls.instance;

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

	override function update(elapsed:Float) {
		//everyStep();
		if(!persistentUpdate) StateManager.timePassedOnState += elapsed;

		super.update(elapsed);
	}
}
