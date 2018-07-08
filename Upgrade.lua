--
-- Created By: Tanner Brown
-- Date: 7/7/2018
-- Project: brickbreaker
-- File: /Upgrade.lua
--

Upgrade = Class{}

function Upgrade:init(x, y)

    self.active = false
    self.x = x
    self.y = y
    self.width = 5
    self.height = 5

    self.activeColor = RED
    self.ctr = 0
    self.dy = 50

end

function Upgrade:update(dt)
    self.y = self.y + self.dy * dt
    if self.ctr == 50 then
        self.ctr = 0
        if self.activeColor == RED then
            self.activeColor = PURPLE
        elseif self.activeColor == PURPLE then
            self.activeColor = GREEN
        elseif self.activeColor == GREEN then
            self.activeColor = BLUE
        elseif self.activeColor == BLUE then
            self.activeColor = YELLOW
        elseif self.activeColor == YELLOW then
            self.activeColor = BLUE
        end
    else
        self.ctr = self.ctr+1
    end
    self.dy = self.dy + 3
    if self.y > VIRTUAL_HEIGHT then
        self.active = false
        self.dy = 50
    end
end

function Upgrade:render()


    love.graphics.setColor(self.activeColor)
    love.graphics.circle('fill', self.x, self.y, self.width, 5)
end

function Upgrade:collides(object)
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

function Upgrade:activate()
    sounds['upgrade']:play()
    if self.activeColor == RED then --speed up time
        breaker.topSpeed = breaker.topSpeed * 1.25
        breaker.dy = breaker.dy * 1.25
        breaker.dx = breaker.dx * 1.25

    elseif self.activeColor == PURPLE then --widen player
        if player.isWide == false then
            player.width = player.width * 2
            player.isWide = true
        end

    elseif self.activeColor == GREEN then --1Up
        gLives = gLives + 1

    elseif self.activeColor == BLUE then --slow time
        breaker.topSpeed = breaker.topSpeed * 0.7
        breaker.dy = breaker.dy * 0.7
        breaker.dx = breaker.dx * 0.7

    elseif self.activeColor == YELLOW then --big ball
        breaker.width = breaker.width * 2

    end
    self.active = false
    self.dy = 75
end

