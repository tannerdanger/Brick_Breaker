--
-- Created by IntelliJ IDEA.
-- User: Tanner
-- Date: 7/4/2018
-- Time: 11:58 AM
-- To change this template use File | Settings | File Templates.
--

Brick = Class{}


UPGRADES = {}
--TODO: Create states, so each brick has to be hit a certain amount of times that changes when a brick is hit
function Brick:init(x, y, width, height, colorNum)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    --set colors based on random number gen
    if colorNum >= 3 then
        self.activeColor = RED
    elseif colorNum == 2 then
        self.activeColor = GREEN
    else
        self.activeColor = BLUE
    end

end



function Brick:hit()
    if self.activeColor == RED then
        self.activeColor = BLUE
        return true
    elseif self.activeColor == BLUE then
        self.activeColor = GREEN
        return true
    elseif self.activeColor == GREEN then
        return false
    end
    return false

end

function Brick:render()

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

end

--randomly applies game modifiers after a brick is broken
function Brick:tryRNG()
    local rand = love.math.random(2,4) --1/5 chance of an upgrade
    if rand == 3 then
        gUpgrade.x = self.x
        gUpgrade.y = self.y
        gUpgrade.active = true
    end



end


