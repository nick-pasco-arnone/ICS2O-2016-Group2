-- shop
local amountofhints
local hints
local counter = 0
displayMode(FULLSCREEN)

SHOP = class()

function setup()
    State=hintstate    
    
    
end

function draw()
    sprite("Dropbox:companyLogoImage", WIDTH/2, HEIGHT/2, WIDTH, HEIGHT)
    fill(255)
    State()
    
    fill(0, 0, 0, 255)
    fontSize(25)
    font("AmericanTypewriter")
    amountofhints = text("amount of hints", WIDTH/8, HEIGHT/1.1)
    text(counter,WIDTH/4.1, HEIGHT/1.1)
end

function hintstate()
    sprite("Dropbox:Blue Back Circle Button", WIDTH/15, HEIGHT/10)
    sprite("Dropbox:shop keep",WIDTH/2,175,150,150)
    showText()
end

function gameState4()
    fontSize(40)
    sprite("Dropbox:yes",WIDTH*.5,600,70,70)
    sprite("Dropbox:no",WIDTH*.5,400,70,70)
    fontSize(30)
    showText1()
end

function gameState5()
    background(255, 12, 0, 119)
    fontSize(30)
    showText3()
end

function showText()
    fontSize(20)
    text("Press here if you want a hint",WIDTH/2,275)    

end

function showText1()
    fontSize(60)
    text("Are you sure?",WIDTH/2,275) 
end 


function showText3()
   fontSize(60)
   text("You said yes",WIDTH*.5,500)
end


function touched(t)

    if t.y>100 and t.y<270 and t.x>450 and t.x<570 then
        -- they want a hint ask them if they are sure
        State=gameState4
        
    end

    -- see if they've touched the yes
    if t.y>360 and t.y<450 and t.x>470 and t.x<570 then
        -- they touched no
     State=hintstate
    
    end

    if t.y>580 and t.y<630 and t.x>490 and t.x<550 then
        -- they touched yes
        State=hintstate   
        counter= counter + 0.5
        -- updates counter 
    end
    

    
end
