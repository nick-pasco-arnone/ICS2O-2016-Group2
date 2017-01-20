-- Settings


function setup()
     displayMode(FULLSCREEN)
    

end


function draw()
fill(0, 0, 0, 255)
font("AmericanTypewriter")
fontSize(65)
sprite("Dropbox:companyLogoImage", WIDTH/2, HEIGHT/2)
text("MUSIC", WIDTH/3, HEIGHT/2)
sprite("Dropbox:on", WIDTH/2, HEIGHT/2, 100, 100)
sprite("Dropbox:off", WIDTH/1.6, HEIGHT/2, 100, 100)   
end
