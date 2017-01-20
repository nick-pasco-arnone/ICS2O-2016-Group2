-- ICS2O-2016-Group2
-- GameLogoScene

-- Created by: Jeremy Dwyer
-- Created on: Nov-2016
-- Created for: ICS2O
-- This is the project for Group #2-2016
-- This is the second scene to show up, the game logo.

GameLogoScene = class()

-- local variables to this scene


-- Use this function to perform your initial setup for this scene
function GameLogoScene:init()
    -- set up display options
    supportedOrientations(LANDSCAPE_ANY)
    noFill()
    noSmooth()
    noStroke()
    pushStyle()  
    
    -- scene setup code here
     -- scene setup code here
    startTime = ElapsedTime
    
end

function GameLogoScene:draw()
    -- Codea does not automatically call this method
    
  background(0, 207, 255, 255)
    sprite("Dropbox:gameLogo", WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)
    -- Do your drawing here
    if(startTime + 3 < ElapsedTime) then
        Scene.Change("testScene")
    end
end

function GameLogoScene:touched(touch)
    -- Codea does not automatically call this method
    
    -- Do your touch code here
    
end