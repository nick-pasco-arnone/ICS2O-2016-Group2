displayMode(FULLSCREEN)
hideKeyboard()

function setup()
    touches = Touches()
    mfont = Font({name = "Futura-Medium",size = 150})
    lfont = Font({name = "Futura-Medium",size = 16})
    anagram = Anagram(mfont,lfont,touches)
end

-- This function gets called once every frame
function draw()
    -- process touches and taps
    touches:draw()
    background(0,0,0)
    
    pushStyle()
    fill(255)
    textMode(CORNER)
    text("Drag letters to form words!", 20, HEIGHT - 50)
    popStyle()
    
    -- draw elements
    anagram:draw(WIDTH/2,HEIGHT/2)
end

function touched(touch)
    touches:addTouch(touch)
end



