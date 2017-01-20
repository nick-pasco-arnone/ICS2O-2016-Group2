Test = class()
local playButton
function Test:init(x)
    -- you can accept and set parameters here
    sprite("Dropbox:playButton")
    playButton = Button("Dropbox:playButton", vec2(WIDTH/2, HEIGHT/2))
    
end

function Test:draw()
    -- Codea does not automatically call this method
    playButton:draw()
end

function Test:touched(touch)
    -- Codea does not automatically call this method
    playButton:touched(touch)
    
    if(playButton.selected == true) then
        Scene.Change("mainMenuScene")      
    end
end
