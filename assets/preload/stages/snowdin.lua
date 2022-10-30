function onCreate()

	
	
	makeAnimatedLuaSprite('snow','horror/snow',-1250,-400);
	addAnimationByPrefix('snow','snow fall','snow', 24, true);
	setObjectOrder('snow',getObjectOrder('snowdin')+6);
	
	scaleObject('snow',1.2,1.2);
	makeLuaSprite('snowdin','horror/snowdin',-1250,-400);
	setLuaSpriteScrollFactor('snowdin',0.9,0.9);
	scaleObject('snowdin',1.2,1.2);
	makeLuaSprite('sohungry','horror/sohungry',-440,-350);
	setLuaSpriteScrollFactor('sohungry',0.9,0.9);
	makeLuaSprite('bone1','horror/hungrybg',-1350,100)
	makeLuaSprite('bone2','horror/hungrybg',350,100)
	setProperty('bone2.flipX',true)
	setProperty('bone1.color',getColorFromHex('f06a65'))
	setProperty('bone2.color',getColorFromHex('f06a65'))
	
	
	addLuaSprite('snowdin')
	addLuaSprite('snow fall',true)
	addLuaSprite('sohungry')
	addLuaSprite('bone1')
	addLuaSprite('bone2')
	setProperty('sohungry.alpha',0)
	setProperty('bone1.alpha',0)
	setProperty('bone2.alpha',0)
	setProperty('sohungry.scale.x',2)
	objectPlayAnimation('snow','snow fall')
end
function opponentNoteHit(id, direction, noteType, isSustainNote)  
	if getProperty('dad.curCharacter') == 'hungrysans' then
    cameraShake('game', 0.003, 0.1)
	end

end
function onUpdate(elapsed)
if getProperty('fear') >= 1.9999 then
setProperty('dad.alpha',0)
setProperty('boyfriend.alpha',0)
setProperty('snow.visible',false)
setProperty('snowdin.visible',false)
end
end
function onStepHit()
if curStep == 1146 then
runTimer('hideeverything',0.43)
end
if curStep == 1186 then
runTimer('easyMEAL',0.01)
end
if curStep == 1440 then
doTweenAlpha('fadeout','sohungry',0,1.784)
end
if curStep == 2016 then
setProperty('snowdin.visible',true)
setProperty('sohungry.alpha',0)
setProperty('bone1.alpha',0)
setProperty('bone2.alpha',0)
end
end
function onTimerCompleted(tag)
if tag == 'hideeverything' then
setProperty('dad.alpha',0)
setProperty('boyfriend.alpha',0)
setProperty('snow.visible',false)
setProperty('snowdin.visible',false)
end
if tag == 'easyMEAL' then
setProperty('dad.alpha',1)
setProperty('boyfriend.alpha',1)
setProperty('sohungry.alpha',1)
end
if tag == 'fadedelay' then
doTweenAlpha('fadein','sohungry',1,0.1)
setProperty('bone1.alpha',1)
setProperty('bone2.alpha',1)
end
end
function onTweenCompleted(tag)
if tag == 'fadeout' then
runTimer('fadedelay',1)
end
end
