--
-- Created By: Tanner Brown
-- Date: 7/7/2018
-- Project: brickbreaker
-- File: states/TitleState
--

TitleState = Class{__includes = BaseState}

function TitleState:init()
    -- nothing
end

function TitleState:update(dt)
    if love.keyboard.isDown('return') then
  --  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end
end

function TitleState:render()


    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Welcome to Brick Breaker!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Press Enter to Begin', 0, 100, VIRTUAL_WIDTH, 'center')

end