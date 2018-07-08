--
-- Created By: Tanner Brown
-- Date: 7/4/2018
-- Project: brickbreaker
-- File: states/ServeState
--
ServeState = Class{__includes = BaseState}



function ServeState:init()
    print("init")
    self.score = 0
    self.lives = 3
    self.playerSpeed = PLAYER_SPEED
end


function ServeState:update(dt)


    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        player.dx = -PLAYER_SPEED
        breaker.dx = player.dx


    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        player.dx = PLAYER_SPEED
        breaker.dx = player.dx


    else
        player.dx = 0
        breaker.dx = 0
    end

    if love.keyboard.isDown('space') then
        breaker:serve(player.dx)
        gStateMachine:change('play')
    end

    player:update(dt)
    breaker:update(dt)

end

function ServeState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Press SPACE to serve', 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255,255,255)
    player:render()
    breaker:render()
    for k, v in pairs(gBricks) do
        love.graphics.setColor(gBricks[k].activeColor)
        v:render()
    end
end



