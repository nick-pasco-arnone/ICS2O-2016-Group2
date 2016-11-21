-- ICS2O-2016-Group2
-- CompanyLogoScene

-- Created by: Mr. Coxall
-- Created on: Nov-2016
-- Created for: ICS2O
-- This is the project for Group #2-2016
-- This is the first scene to show up, the company logo.

CompanyLogoScene = class()

-- local variables to this scene


-- Use this function to perform your initial setup for this scene
function CompanyLogoScene:init()
    -- set up display options
    supportedOrientations(LANDSCAPE_ANY)
    noFill()
    noSmooth()
    noStroke()
    pushStyle()  
    
    -- scene setup code here
    
end

function CompanyLogoScene:draw()
    -- Codea does not automatically call this method
    
    background(255, 0, 0, 255)
    
    -- Do your drawing here
    
end

function CompanyLogoScene:touched(touch)
    -- Codea does not automatically call this method
    
    -- Do your touch code here
    
end