function onCreate()
--insert code here
	
end

function onMoveCamera(focus)
    if focus == 'dad' then
        setProperty('defaultCamZoom', .9)
    elseif focus == 'boyfriend' then
        setProperty('defaultCamZoom', 0.8)
    end
end

function onUpdate()
--fake 3d oooo
    zoomshit = (getProperty('camGame.zoom')/0.75);
    setCharacterX('boyfriend',bfx*zoomshit)
    setCharacterY('boyfriend',bfy*zoomshit)
    setProperty('boyfriend.scale.x',zoomshit)
    setProperty('boyfriend.scale.y',zoomshit)
	
end

function onStepHit()
if curStep == 1 then


end

end
dodging = false;
function onUpdatePost(elapsed)

	end

