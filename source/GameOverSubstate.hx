package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxSave;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Boyfriend;
	public static var aliza:FlxSprite;
	public static var grey:FlxSprite;
	public static var deathScreen:FlxSprite;
	public static var retryButton:FlxSprite;
	var learnedlesson = false;
	public static var deathTextNumber:Array<String> = [
		"Down here, it's EAT or BE EATEN...",
		"Remember to press SPACE to dodge his attacks...",
		"You will always go back to the point where you wish you were dead.",
		"There were others who came. None survived...",
		"This is our underground hell...",
		"Why do you even bother trying when you just keep dying?",
		"It's me... Your old friend, Flowey the Flower...",
		"Fun fact: This is based on the Tumblr comic and game, Horrortale. Check it out. It's cool.",
		"Dying is gay...",
		"Our HOPES and DREAMS have been gone for a long time...",
		"But nobody came...",
		"It's been so long since they left...",
		"Never seen a human so stupid to not change the chart."

	];
	public static var torielstuff:Array<String> = [
		"Hmm...",
		"You're new to dying, aren'tcha?",
		"My, that's very funny.",
		"Death doesn't work the same around here, and someone ought to teach you a lesson.",
		"Sans is unpredicatable and can't be trusted. Every time he's about to attack you, press SPACE to dodge.",
		"Now...\nGo and retry."
	];
	public static var deathTextNumberer:Int;
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;

	var stageSuffix:String = "";

	public static var characterName:String = 'bf';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var attackIsNowKnown:String = "learnedAttack";
	var deathText:FlxTypeText;
	var canSkip = true;
	public var learnedSave:FlxSave;

	public static var instance:GameOverSubstate;

	public static function resetVariables() {
		characterName = 'aliza';
		deathSoundName = 'fnf_loss_sfx';
		loopSoundName = 'gameOver';
		endSoundName = 'gameOverEnd';
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float)
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		boyfriend = new Boyfriend(x, y, characterName);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		

		add(boyfriend);
		if (PlayState.SONG.song == 'eat-or-be-eaten') {
			deathSoundName = 'soulbreaks';
			loopSoundName = 'horrorGameOver';
			endSoundName = 'horrorGameOverEnd';

			trace('aliza is dead');
			canSkip = false;
			boyfriend.screenCenter();
			boyfriend.animation.play('firstDeath');
			grey = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xff1d1d1d);
					add(grey);
					grey.alpha=0;
					grey.screenCenter();
					deathScreen = new FlxSprite().loadGraphic(Paths.image('horrorgameoverscreen'));
					deathScreen.setGraphicSize(Std.int(deathScreen.width * 1.15));
					add(deathScreen);
					deathScreen.antialiasing = true;
					deathScreen.screenCenter();
					deathScreen.alpha = 0;
					retryButton = new FlxSprite(850,400);
					retryButton.frames = Paths.getSparrowAtlas('resetbutton');
					retryButton.setGraphicSize(Std.int(retryButton.width * 1.15));
					retryButton.animation.addByPrefix('confirm','deathconfirm',12,false);
					retryButton.animation.addByIndices('idle','deathloop', [1], "",12,true);
					retryButton.antialiasing = true;
					add(retryButton);
					retryButton.alpha = 0;
			FlxG.camera.zoom = 0.9;
			new FlxTimer().start(3.5, function(tmr:FlxTimer)
				{
					FlxTween.tween(grey, {alpha: 1}, 2, {
						
					});
					FlxTween.tween(deathScreen, {alpha: 1}, 2, {onComplete: function (twn:FlxTween) {
						if(PlayState.dunkedon && !PlayState.learnedlesson)
							{
								trace('dunkedon is ' + PlayState.dunkedon);
								canSkip = false;
								tutoriel();
							}
						else {
						canSkip = true;
						deathTextNumberer = FlxG.random.int(0,11);
						deathText = new FlxTypeText(780, 110, 400, deathTextNumber[deathTextNumberer]);
						deathText.setFormat(Paths.font("Gabriola.ttf"), 40, FlxColor.BLACK, LEFT);
						add(deathText);
						deathText.prefix = "*";
						deathText.antialiasing = true;
						deathText.start(0.05);
						deathText.sounds = [FlxG.sound.load(Paths.sound('floweytalks'))];
					}}
					});
					if(PlayState.dunkedon && !PlayState.learnedlesson)
					{
					}else
							{
					FlxTween.tween(retryButton, {alpha: 1}, 2, {
						
					});
					}
				});
		}
		camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		FlxG.sound.play(Paths.sound(deathSoundName));
		Conductor.changeBPM(100);
		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');

		var exclude:Array<Int> = [];

		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2));
		add(camFollowPos);
	}
	var toriel:FlxTypeText;
	var torielStep:Int = 0;
	var isFollowingAlready:Bool = false;
	function onComplete():Void
		{
			new FlxTimer().start(2.5, function(tmr:FlxTimer)
				{
					if(torielStep < 5)
						{
							torielStep += 1;
							remove(toriel);
							tutoriel();
						}
					else if(torielStep == 5){
						trace('You can skip now');
					}
				});
		}
	function tutoriel() 
		{
			toriel = new FlxTypeText(780,110,400, torielstuff[torielStep]);
			toriel.setFormat(Paths.font("Gabriola.ttf"), 40, FlxColor.BLACK, LEFT);
			add(toriel);
			toriel.antialiasing = true;
			toriel.prefix = "*";
			toriel.start(0.05,false,false,null,onComplete.bind());
			toriel.sounds = [FlxG.sound.load(Paths.sound('floweytalks'))];
			if(torielStep == 5)
				{
					new FlxTimer().start(.3, function(tmr:FlxTimer)
						{
							toriel.paused = true;
							new FlxTimer().start(1.5, function(tmr:FlxTimer)
								{
									toriel.paused = false;
								});
							FlxTween.tween(retryButton, {alpha: 1}, 2,{onComplete: function (twn:FlxTween) {
								PlayState.learnedlesson = true;
								canSkip = true;
								PlayState.attackKnown = true; //Knowing Sans will betray you fills you with FEAR...

								FlxG.save.data.attackKnown = PlayState.attackKnown;
								FlxG.save.data.learnedlesson = PlayState.learnedlesson;
							}});
						});
				}
		}
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (controls.ACCEPT)
		{
			if (canSkip == true)
				{
			endBullshit();
				}
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;

			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
		}

		if (boyfriend.animation.curAnim.name == 'firstDeath')
		{
			if(boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
			{
				FlxG.camera.follow(camFollowPos, LOCKON, 1);
				updateCamera = true;
				isFollowingAlready = true;
			}

			if (boyfriend.animation.curAnim.finished)
			{
				coolStartDeath();
				boyfriend.startedDeath = true;
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();

		//FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			if (PlayState.SONG.song == 'eat-or-be-eaten')
				{
					retryButton.animation.play('confirm');
					if (PlayState.dunkedon){
					PlayState.dunkedon = false;
				}else{
					deathText.skip();}
				}
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
			PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
		}
	}
}
