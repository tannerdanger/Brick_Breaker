--
-- Created by IntelliJ IDEA.
-- User: Tanner
-- Date: 7/4/2018
-- Time: 11:58 AM
-- To change this template use File | Settings | File Templates.
--
Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
    self.speed = 200
end

function Paddle:update(dt)
    if self.dx < 0 then --moving left left
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
end

--TODO: Changes if powerup is applied