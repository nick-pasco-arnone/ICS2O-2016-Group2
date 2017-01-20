-- Achivments

function setup()
    displayMode(FULLSCREEN)
end

-- This function gets called once every frame
function draw()
sprite("Dropbox:companyLogoImage", WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)
    fill(7, 7, 7, 255)
   sprite("Dropbox:Blue Back Circle Button", WIDTH/15, HEIGHT/10)
    
    
     sprite("Cargo Bot:Star Filled", WIDTH/4, HEIGHT/3, 150, 150)
    text("Finish the first world", WIDTH/4, HEIGHT/3)
    
    sprite("Cargo Bot:Star Filled", WIDTH/2, HEIGHT/3, 150, 150)
    text("Finish the second world", WIDTH/2, HEIGHT/3)
    
    sprite("Cargo Bot:Star Filled", WIDTH/1.3, HEIGHT/3, 150, 150)
    text("Finish the game", WIDTH/1.3, HEIGHT/3)
        
    
    
    sprite("Cargo Bot:Star Filled", WIDTH/4, HEIGHT/1.6, 150, 150)
    text("Finish the tutorial", WIDTH/4, HEIGHT/1.6)
    
    sprite("Cargo Bot:Star Filled", WIDTH/2, HEIGHT/1.6, 150, 150)
    text("Finish the first level", WIDTH/2, HEIGHT/1.6)
    
    sprite("Cargo Bot:Star Filled", WIDTH/1.3, HEIGHT/1.6, 150, 150)
    text("purchase a hint", WIDTH/1.3, HEIGHT/1.6)
    
end
