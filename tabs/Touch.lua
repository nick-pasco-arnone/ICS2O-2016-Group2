-- Touch handler class
-- Author: Andrew Stacey
-- Website: http://www.math.ntnu.no/~stacey/HowDidIDoThat/iPad/Codea.html
-- Licence: CC0 http://wiki.creativecommons.org/CC0

--[[
The classes in this file are for handling touches.  The classes are:

Touches: this is the controller class which gathers touches, figures
out which object they belong to, and passes the information to those
objects in an orderly manner as a "gesture".

Gesture: a gesture is a collection of touches that are "alive" and
claimed by the same object.  A gesture is analysed before being passed
to an object to help provide some information as to what type of
gesture it is.

Touch: this represents a touch as a single object (from start to
finish) and is updated by the controller as new information comes in.
--]]

Touches = class()

--[[
The controlling object has an array of touches, an array of handlers,
and an array of "active touches".

When a "touch" object is registered by Codea, the handler takes it and
tries to work out what to do with it.  When a touch begins, the
handler creates a "Touch" object surrounding it.  As new information
comes in, via new "touch" objects, this needs to be linked to the
correct "Touch" object.  The handler uses the "touch.id" to do this,
but this creates a problem: although the "touch.id" is guaranteed to
be unique in the lifetime of the touch, it might be reused afterwards.
For complicated gestures, it is useful to have "Touch" objects persist
beyond the liftetime of the actual touch.  So more than one Touch can
correspond to the same "touch.id".  To get round this, we maintain a
list of "active" touches: ie ones that have not officially ended.
These are the ones that accept new information.
--]]

function Touches:init()
    self.touches = {}
    self.handlers = {}
    self.numTouches = 0
    self.actives = {}
end

--[[
This is where a touch is initially analysed.  If it is a new touch
then a Touch object is created.  Then each of the handlers in turn is
asked if it wants to "claim" the touch.  The first one to do so is
assigned the touch.  If none do, it is consigned to the bin.

There is a slight wrinkle in the above: it is possible for an object
to specify an "interrupt" which is given first priority in the
claimant queue.  Sometimes an object might want to take some action
"until the next touch", wherever that touch may be: this is to allow
for that.

If a touch is not new, its information is used to update the
corresponding active Touch object.
--]]

function Touches:addTouch(touch)
    if touch.state == BEGAN then
        self.numTouches = self.numTouches + 1
        self.touches[self.numTouches] = Touch(touch)
        self.touches[self.numTouches].container = self
        self.touches[self.numTouches].id = self.numTouches
        self.actives[touch.id] = self.numTouches
        if
            not self.interrupt 
            or 
            not self.interrupt:interruption(
                    self.touches[self.actives[touch.id]]
                )
        then
            for k,v in ipairs(self.handlers) do
                if v[1]:isTouchedBy(touch) then
                    v[2]:addTouch(self.touches[self.actives[touch.id]])
                    break
                end
            end
        end
        if not self.touches[self.actives[touch.id]].gesture then
            self.touches[self.actives[touch.id]] = nil
            self.actives[touch.id] = nil
        end
    elseif touch.state == MOVING then
        if self.actives[touch.id] then
            self.touches[self.actives[touch.id]]:update(touch)
        end
    elseif touch.state == ENDED then
        if self.actives[touch.id] then
            self.touches[self.actives[touch.id]]:update(touch)
        end
    end
end

--[[
This adds a new handler at the end of the list, creating a gesture to
contain its touches.
--]]

function Touches:pushHandler(h)
    local g = Gesture()
    table.insert(self.handlers,{h,g})
end

--[[
This adds a new handler at the start of the list, creating a gesture to
contain its touches.
--]]

function Touches:unshiftHandler(h)
    local g = Gesture()
    table.insert(self.handlers,1,{h,g})
end

--[[
The draw function is used to process the touch information gathered in
the current cycle.  Gestures are analysed and then passed to the
corresponding handers.
--]]

function Touches:draw()
    if self.handlers then
        for k,v in pairs(self.handlers) do
            if v[2].num > 0 then
                v[2]:analyse()
                v[1]:processTouches(v[2])
                if v[2].type.finished then
                    v[2]:reset()
                end
            end
        end
    end
end

function Touches:reset()
    self.touches = {}
    self.numTouches = 0
    self.actives = {}
end

function Touches:pause()
end

--[[
A gesture is a group of touches that are handled by the same object
and are "alive" at the same time.  A gesture is analysed before being
passed to its object and certain basic information is gathered that
can be analysed by the handling object.  Most of this information is
stored in the "type" array with two notable exceptions.  The main list
is as follows (there are some others which are used for implementation
reasons that can nonetheless be used, but the following contains all
the available information):

num: the number of touches in the gesture.

updated: has there been new information since the gesture was last
looked at?

type.tap: this is true if none of the touches have moved

type.long: this is true if all of the touches waited a significant
length of time (currently .5s) between starting and ending or moving.

type.short: this is true if all of the touches were of short duration
(less that .5s).  Note that "short" and "long" are not opposites.

type.ended: if all the touches have ended.

type.finished: if all the touches ended at least .5s ago.  The
distinction between "ended" and "finished" is to allow for things like
multiple taps to be registered as a single gesture.

type.pinch: if the gesture consists of multiple movements, the gesture
tries to see if they are moving towards each other or parallel.  It
does this by looking at the relative movement of the barycentre of the
touch compared to the average magnitude of the movements of the
individual touches.
--]]

Gesture = class()

--[[
Initialise our data.
--]]

function Gesture:init()
    self.touches = {}
    self.num = 0
    self.updated = true
    self.updatedat = ElapsedTime
    self.type = {}
end

--[[
Add a touch to the list.
--]]

function Gesture:addTouch(touch)
    self.num = self.num + 1
    self.touches[touch.id] = touch
    touch.gesture = self
    self.updated = true
    self.updatedat = ElapsedTime
    return true
end

--[[
Remove a touch from the list.
--]]

function Gesture:removeTouch(touch)
    self.touches[touch.id] = nil
    touch.gesture = nil
    self.num = self.num - 1
    self.updated = true
    self.updatedat = ElapsedTime
    self.type = {}
    return true
end

--[[
Resets us to a "blank" state.  Called by the touch controller at the
end of the cycle if we are "finished" but can be called by our object
at an earlier stage.
--]]

function Gesture:reset()
    self.touches = {}
    self.num = 0
    self.updated = true
    self.updatedat = ElapsedTime
    self.type = {}
end

--[[
The "updated" field is so that the object knows that new information
has come in.  So it is for the object to say "I am done with this
information, wake me again when there is new stuff" by calling this
routine.
--]]

function Gesture:noted()
    self.updated = false
    for k,v in pairs(self.touches) do
        v.updated = false
    end
end

--[[
This is the analyser that works out the basic information about the
gesture.  Most of the information is of the "if all touches are X, so
are we" or "if at least one touch is X, so are we" (which are
equivalent via negation).  The exception is the "pinch".
--]]

function Gesture:analyse()
    local b = vec2(0,0)
    local d = 0
    local c
    self.touchesArr = {}
    self.type.ended = true
    self.type.notlong = false
    for k,v in pairs(self.touches) do
        table.insert(self.touchesArr,v)
        if v.moved then
            self.type.moved = true
        end
        if v.touch.state ~= ENDED  then
            self.type.ended = false
        end
        if not v:islong() then
            self.type.notlong = true
        end
        if not v:isshort() then
            self.type.notshort = true
        end
        c = vec2(v.touch.deltaX,v.touch.deltaY)
        b = b + c
        d = d + c:lenSqr()
    end
    if not self.type.moved then
        -- some sort of tap
        self.type.tap = true
    else
        self.type.tap = false
    end
    if self.type.ended and (ElapsedTime - self.updatedat) > .5 then
        self.type.finished = true
    end
    self.type.long = not self.type.notlong
    self.type.short = not self.type.notshort
    if self.num > 1 and not self.type.tap then
        if d * self.num < 1.5 * b:lenSqr() then
            self.type.pinch = false
        else
            self.type.pinch = true
        end
    end
end

--[[
This is an extension of the "touch" class, providing a single object
that corresponds to what a user would call a "touch".  It also
provides more information than is contained in a single "touch"
object.
--]]

Touch = class()

--[[
Initialiser function.
--]]

function Touch:init(touch)
    self.id = touch.id
    self.touch = touch
    self.firsttouch = touch
    self.updated = true
    self.updatedat = ElapsedTime
    self.createdat = ElapsedTime
    self.startedat = ElapsedTime
    self.deltatime = 0
    self.laststate = 0
    self.moved = false -- did we move?
    self.long = false  -- long time before we did anything?
    self.short = false -- active lifetime was short?
    self.keepalive = false
end

--[[
Updates new information from a "touch" object.
--]]

function Touch:update(touch)
        -- save previous state
        self.laststate = touch.state
        self.deltatime = ElapsedTime - self.updatedat
        self.updatedat = ElapsedTime
        -- Update the touch
        self.touch = touch
        -- Regard ourselves as "refreshed"
        self.updated = true
        if self.gesture then
            self.gesture.updated = true
            self.gesture.updatedat = ElapsedTime
        end
        if self.laststate == BEGAN then
            self.startedat = ElapsedTime
        end
        -- record whether we've moved
        if touch.state == MOVING then
            self.moved = true
        end
        -- if it was a long time since we began, we're long
        if self.laststate == BEGAN and self.deltatime > 1 then
            self.long = true
        end
        if touch.state == ENDED then
            -- If we've ended and it's less than a second since we 
            -- actually did something, we're short
            if (ElapsedTime - self.startedat) < 1 then
                self.short = true
            end
        end
        return true
end

--[[
Regard ourselves as "dealt with" until new information comes in.
--]]

function Touch:handled()
    self.updated = false
end

--[[
Do our level best to get rid of ourselves, removing ourself from the
gesture and touch controller.
--]]

function Touch:destroy()
    if self.gesture then
        self.gesture:removeTouch(self)
    end
    if self.container then
        if self.container.actives[self.touch.id] == self.id then
            self.container.actives[self.touch.id] = nil
        end
        self.container.touches[self.id] = nil
    end
    self = nil
end

--[[
Test to find out if we are "long"
--]]

function Touch:islong()
    if self.long then
        return self.long
    elseif self.touch.state == BEGAN and (ElapsedTime - self.createdat) > 1 then
        self.long = true
        return true
    else
        return false
    end
end

--[[
Test to find out if we are "short"
--]]

function Touch:isshort()
    if self.short then
        return self.short
    elseif (ElapsedTime - self.startedat) < 1 then
        return true
    else
        return false
    end
end

