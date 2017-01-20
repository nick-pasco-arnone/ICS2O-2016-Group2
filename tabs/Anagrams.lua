Anagram = class()

function Anagram:init(f,lf,t)
    self.font = f
    self.lfont = lf
    self.lh = f:lineheight()
    self.llh = lf:lineheight()
    self.colour = Colour.svg.White
    self.highlight = Colour.svg.Red
    self.rightcol = Colour.svg.HotPink
    self.wlist = {}
    self.words = {}
    local s
    self.ww = 0
    self.mwords = math.floor(HEIGHT/self.llh)
    self.nwords = 0
    local n = 0
    local words = Words
    for k,v in ipairs(words) do
        n = n + 1
    end
    self.mwords = math.min(self.mwords,n)
    for i = 1,n do
        j = math.random(i,n)
        words[i],words[j] = words[j],words[i]
    end
    local st
    if n <= self.mwords then
        st = 1
    else
        st = math.random(1,n - self.mwords + 1)
    end
    local abc = 0
    for i = st,st + self.mwords-1 do
        s = Sentence(lfont,words[i])
        s:prepare()
        s:setColour(Colour.svg.White)
        self.ww = math.max(self.ww,s.width)
        self.nwords = self.nwords + 1
        table.insert(self.wlist,s) 
        table.insert(self.words,words[i])
        abc = abc + 1
    end
    self.ww = WIDTH - self.ww - 10
    t:pushHandler(self)
    
    self.fireworks = Fireworks()

    self.score = -1
    self.scoret = Sentence(lfont,"Score: ")
    self.scoret:setColour(Colour.svg.White)
    self.scoren = Sentence(lfont,self.score)
    self.scoren:setColour(Colour.svg.White)
    self:newword()
end

function Anagram:newword()
    local nword = self.word
    while nword == self.word do
        nword = self.words[math.random(1,self.mwords)]
    end
    self.word = nword
    local s = Sentence(self.font,self.word)
    s:prepare()
    self.cw = s.width
    self.l = 0
    self.chars = {}
    local uword = UTF8(self.word)
    for c in uword:chars() do
        self.l = self.l + 1
        local l = self.l
        table.insert(self.chars,{c,l})
    end
    local j,wd,ch,l
    wd = self.word
    while (wd == self.word) do
    for i = 1,self.l do
        j = math.random(i,self.l)
        self.chars[i],self.chars[j] = self.chars[j],self.chars[i]
    end
    wd = ""
    for k,c in ipairs(self.chars) do
        ch,l = unpack(c)
        wd = wd .. string.char(ch)
    end
    end
    self.lh = self.font:lineheight()
    
    self.x = 0
    self.y = 0
    self.xx = {}
    self.guessed = false
    self.score = self.score + 1
    self.scoren:setString(self.score)
end

function Anagram:draw(x,y)
    local st = 0
    if self.guessed then
        st = self.fireworks:draw()
        if not self.fireworks.active then
            self:newword()
        end
    end
    local h = HEIGHT
    fill(255, 0, 0, 255)
    for k,v in ipairs(self.wlist) do
        h = h - self.llh
        v:draw(self.ww,h)
    end
    x = x - self.cw/2
    local col = self.colour
    local letcol
    self.x = x
    self.y = y
    self.xx = {}
    self.fx = {}
    local ch
    local l
    local right = false
    local s = {}
    for k,c in ipairs(self.chars) do
        ch,l = unpack(c)
        table.insert(s,ch)
    end
    s = string.char(unpack(s))
    if s == self.word and not self.intouch then
        right = true
    end
    if right then
        col = self.rightcol
    end
    local ox
    local lh = self.lh/2
    for k,c in ipairs(self.chars) do
        ch,l = unpack(c)
        if k <= st then
            letcol = color(0,0,0,0)
        elseif self.letter == k then
            letcol = self.highlight
        else
            letcol = col
        end
        ox = x
        x,y = self.font:write_utf8(ch,x,y,letcol)
        table.insert(self.xx,x)
        table.insert(self.fx,{(x + ox)/2,y + lh})
    end
    local sx,sy
    sx,sy = self.scoret:draw(20,50)
    self.scoren:draw(sx,sy)
    if right and not self.guessed then
        self.guessed = true

        if self.word then
            speech.rate = 0.1
            speech.say(self.word)
        end

        -- create new fireworks
        self.fireworks:newshow(self.fx)
    end
end

function Anagram:isTouchedBy(touch)
    if self.guessed then
        return false
    end
    if touch.x < self.x then
        return false
    end
    if touch.x > self.x + self.cw then
        return false
    end
    if touch.y < self.y then
        return false
    end
    if touch.y > self.y + self.lh then
        return false
    end
    self.intouch = true
    return true
end

function Anagram:processTouches(g)
    if g.updated then
    if g.num == 1 then
        local t = g.touchesArr[1]
        if self.guessed and t.touch.state == BEGAN then
            self:newword()
        else
        local letter = self.l
        for k,x in ipairs(self.xx) do
            if t.touch.x < x then
                letter = k
                break
            end
        end
        if self.letter then
            self.chars[letter],self.chars[self.letter] = self.chars[self.letter],self.chars[letter]
        end
        self.letter = letter
        if t.touch.state == ENDED then
            self.letter = nil
        end
            
    end
    end
    g:noted()
    end
    if g.type.ended then
        self.intouch = false
        g:reset()
    end
end

function Anagram:createFirework(x,y,colour)
    local pos = freePos(self.fireworks)
    self.fireworks[pos] = Firework(x,y,colour)
end

function Anagram:createSmoke(x,y)
    local pos = freePos(self.smokes)
    self.smokes[pos] = Smoke(x,y,3)
end

function freePos(list)
    return freePosRecursive(list,1)
end

function freePosRecursive(list,n)
    if list[n] == nil then
        return n
    else
        return freePosRecursive(list,n+1)
    end
end
