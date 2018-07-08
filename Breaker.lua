--
-- Created by IntelliJ IDEA.
-- User: Tanner
-- Date: 7/4/2018
-- Time: 11:58 AM
-- To change this template use File | Settings | File Templates.
--

Breaker = Class{}

function Breaker:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.topSpeed = 200
    self.defW = width
    --these variables keep track of velocity on both the x,y axis
    -- the and/or pattern here is Lua's way of accomplishing a ternary operation
    -- in other programming languages like C
    self.dy = 0--math.random(2) == 1 and -100 or 100 --if math.random(2) = 1, ballDX = 100, else, ballDX = -100
    self.dx = 0--math.random(-50, 50)

end

--TODO: Reset to paddle location
function Breaker:reset(x, y)
    self.x = x --VIRTUAL_WIDTH / 2-2
    self.y = y --VIRTUAL_HEIGHT /2-2
    self.dy = 0
    self.dx = 0
    self.topSpeed = 200
end

function Breaker:serve(dx)
    print("serve dx : " .. tostring(dx))
    if dx < 0 then --serve left
        self.dx = -100
    elseif dx > 0 then --serve right
        self.dx = 100
    else --serve straight w/ slight angle
        self.dx = love.math.random(1,10)
    end
    self.dy = PLAYER_SPEED
    self.width = self.defW
end


    --[[
        Simply applies velocity to position, scaled by deltaTime
     ]]
    function Breaker:update(dt)
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
    end

    function Breaker:render()
        --love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
        love.graphics.setColor(255,255,255)
        love.graphics.circle('fill', self.x, self.y, self.width, 5)
    end

    function Breaker:collides(object)
        --first check to see if left edte of either is further to right then right edge of other
        if self.x > object.x + object.width or object.x > self.x + self.width then
            return false
        end

        -- then check to see if bottom is higher than top of other
        if self.y > object.y + object.height or object.y > self.y + self.height then
            return false
        end
        return true
    end
