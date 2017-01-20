-- ICS2O-2016-Group2
-- MainMenuScene

-- Created by: Jeremy Dwyer
-- Created on: Nov-2016
-- Created for: ICS2O
-- This is the project for Group #2-2016
-- This is the main menu

MainMenuScene = class()

-- local variables to this scene
local startButton

-- Use this function to perform your initial setup for this scene
function MainMenuScene:init()
    -- set up display options
    supportedOrientations(LANDSCAPE_ANY)
    noFill()
    noSmooth()
    noStroke()
    pushStyle()  
    
    -- scene setup code here
    startTime = ElapsedTime
end

function MainMenuScene:draw()
    -- Codea does not automatically call this method
    
    background(219, 142, 13, 255)
    sprite("Dropbox:Background Fade", WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)
  -- Do your drawing here
    end

function MainMenuScene:touched(touch)
    -- Codea does not automatically call this method
    
    -- Do your touch code here
  
   
end