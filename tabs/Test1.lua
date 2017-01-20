Test1 = class()
local GreenSettingsButton
function Test1:init(x)
    -- you can accept and set parameters here
    sprite("Dropbox:Green Settings Button")
   GreenSettingsButton = Button("Dropbox:Green Settings Button", vec2(WIDTH/2, HEIGHT/2))

end

function Test1:draw()
    -- Codea does not automatically call this method
    GreenSettingsButton:draw()
end

function Test1:touched(touch)
    -- Codea does not automatically call this method
   GreenSettingsButton :touched(touch)
    
    if(GreenSettingsButton.selected == true) then
        Scene.Change("mainMenuScene")      
    end
end
