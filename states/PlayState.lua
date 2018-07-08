--
-- Created By: Tanner Brown
-- Date: 7/4/2018
-- Project: brickbreaker
-- File: states/PlayState
--

PlayState = Class{__includes = BaseState}


BRICK_WIDTH = 20
BRICK_HEIGHT = 10

function PlayState:init()


    --draw brick line, probably just for debugging purposes
    love.graphics.setLineStyle("smooth")
    love.graphics.setLineWidth(10)

    love.graphics.line(0,BRICK_LINE,VIRTUAL_WIDTH,BRICK_LINE)

end


function PlayState:update(dt)


    --TODO: Improve math here?
    if breaker:collides(player) then
        sounds['paddle_hit']:play()

        breaker.dy = -breaker.dy
        breaker.y = player.y - 10

    --[[
        print("--------------------------------------------")
        print("----------------NEW TEST--------------------")
        print("--------------------------------------------")
        print("Breaker DX:  " .. tostring(breaker.dx))
        print()
        print("Player DX:  " .. tostring(player.dx))
        print()
        print("DIFFERENCE IN X: ".. tostring(math.abs(player.x - breaker.x)))
        print()
        ]]

        if breaker.dx < 0 then -- if breaker is moving left

            if player.dx < 0 then -- player moving left with breaker (TEST GOOD)

                breaker.dx = math.max(-breaker.topSpeed,  breaker.dx - math.abs((player.x - breaker.x) * 2))
            else -- player is moving right against breaker

                breaker.dx = math.min(breaker.topSpeed,  breaker.dx + math.abs((player.x - breaker.x) * 2))
            end

        else --if breaker is moving right

            if player.dx < 0 then -- player moving left against breaker (TEST GOOD)

                breaker.dx = math.max(-breaker.topSpeed,  breaker.dx - math.abs((player.x - breaker.x) * 2) )

            else -- player is moving right with breaker (TEST GOOD)
                breaker.dx = math.min(breaker.topSpeed,  breaker.dx + math.abs((player.x - breaker.x) * 2) )
            end
        end
        --breaker.dx = breaker.dx * breaker.speed --apply multiplier onto breaker speed
        --[[
        print("---After hit----")
        print("Breaker DX:  " .. tostring(breaker.dx))
        print("--------------------------------------------")
        print("----------------END TEST--------------------")
        print("--------------------------------------------")
        print("--------------------------------------------")
        ]]

    end -- if breaker:collides(player)

    if gUpgrade.active == true then
        if gUpgrade:collides(player) then
            sounds['upgrade']:play()
            gUpgrade:activate()
        end

    end


    if breaker.y < BRICK_LINE then

        for k,v in pairs(gBricks) do

            if breaker:collides(gBricks[k]) then
                gScore = gScore + 2
                breaker.dy = -breaker.dy

                if gBricks[k]:hit() == false then
                    gScore = gScore + 5
                    if gUpgrade.active == false then
                        gBricks[k]:tryRNG()
                    end
                    table.remove(gBricks, k)
                    sounds['score']:play()

                else
                    sounds['brick_hit']:play()
                end
            end
        end
    end

    -- bounce off left of screen
    if breaker.x <= 0 then
        sounds['brick_hit']:play()
        breaker.x = 0
        breaker.dx = -breaker.dx --reverse direction if hit wall
    end
    -- bounce off right of screen
    if breaker.x >= VIRTUAL_WIDTH - breaker.width then
        sounds['brick_hit']:play()
        breaker.x = VIRTUAL_WIDTH - breaker.width
        breaker.dx = -breaker.dx -- reverse direction
    end
    -- bounce off top of screen
    if breaker.y <= 0 then
        sounds['brick_hit']:play()
        breaker.y = breaker.height
        breaker.dy = -breaker.dy
    end

    -- die if fall below screen
    if breaker.y >= VIRTUAL_HEIGHT then
        local gameOver = false
        sounds['explosion']:play()

        if gLives > 0 then
            gLives = gLives - 1
        else
            gameOver = true

        end

        player:reset()
        breaker:reset(player.x + player.width/2 - 2, player.y - player.height)
        if gameOver then
            gStateMachine:change('gameover')
        else
            gStateMachine:change('serve')
        end


    end



    -- paddle movement
    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        player.dx = -PLAYER_SPEED
        --print("player going left at speed: "..tostring(player.dx))
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        player.dx = PLAYER_SPEED
        --print("player going right at speed: "..tostring(player.dx))
    else
        player.dx = 0
    end
    --print("player x location: " .. tostring(player.x))
    player:update(dt)
    breaker:update(dt)
end

function PlayState:render()
    love.graphics.setColor(255,255,255)
    player:render()
    breaker:render()
    for k, v in pairs(gBricks) do
        love.graphics.setColor(gBricks[k].activeColor)
        v:render()
    end
end