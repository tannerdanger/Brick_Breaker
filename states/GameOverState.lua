--
-- Created By: Tanner Brown
-- Date: 7/7/2018
-- Project: brickbreaker
-- File: states/GameOverState
--

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    -- nothing
    print('in game over init')
end

function GameOverState:update(dt)
    print('in game over update')
    if love.keyboard.isDown('return') then
        GameOverState:reset()
        --  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve')
    end
end

function GameOverState:render()

    love.graphics.setColor(255,0,0)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('GAME OVER!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255,255,255)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Press Enter to play again', 0, 100, VIRTUAL_WIDTH, 'center')

end

function GameOverState:reset()
    gScore = 0
    gLives = 3
    player:reset()
    breaker:reset(player.x + player.width/2 - 2, player.y - player.height)

    --clear bricks
    gBricks = {}
    --create the bricks
    local lastBrickX = 13
    local lastBrickY = 30
    for i = 0, 4 do
        for j = 1, 18 do
            table.insert(gBricks, Brick(lastBrickX , lastBrickY , BRICK_WIDTH, 5, love.math.random(5) ))
            lastBrickX = lastBrickX + BRICK_WIDTH + 3
        end
        lastBrickX = 13
        lastBrickY = lastBrickY + 10
    end
    BRICK_LINE = lastBrickY
end