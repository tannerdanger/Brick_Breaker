--
-- Created By: Tanner Brown
-- Date: 7/7/2018
-- Project: brickbreaker
-- File: states/TitleState
--

TitalState = Class{_includes = BaseState}

function TitleScreen:update(dt)
    if love.keyboard.wasPresed('enter') or love.keyboard.wasPressed('return')
        gStateMachine:change('serve')
    end

end