--
-- User: Tanner
-- Date: 7/4/2018
--

--TODO: 1. Adjust the new angle of breaker after contact with paddle
--      2. Lives
--      3. Powerups

Class = require 'class'
push = require 'push'
require 'Brick'
require 'Paddle'
require 'Breaker'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


PLAYER_SPEED = 200
BRICK_WIDTH = 20
BRICK_HEIGHT = 10

require 'StateMachine'
gStateMachine = {}

function love.load()

    --love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Brick Breaker!!")

    -- fonts
    smallFont = love.graphics.newFont('assets/font.ttf', 8)
    largeFont = love.graphics.newFont('assets/font.ttf', 16)
    scoreFont = love.graphics.newFont('assets/font.ttf', 32) --different fonts, because a font object is immutable
    love.graphics.setFont(smallFont)


    -- RNG seed
    math.randomseed(os.time())

    --table of sounds
    sounds = {
        ['paddle_hit'] = love.audio.newSource('assets/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/score.wav', 'static'),
        ['brick_hit'] = love.audio.newSource('assets/wall_hit.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/explosion.wav', 'static')
    }

    --table of stateMachines
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end
    }

    gStateMachine:change('serve')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true --syncs with screen refresh rate
    })


    score = 0
    lives = 3
    player = Paddle(VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT - 10 , 40, 5)
    breaker = Breaker(player.x + player.width/2 - 2, player.y - player.height, 3, 4)

    --create the bricks
    bricks = {}
    lastBrickX = 13
    lastBrickY = 30
    for i = 0, 4 do
        for j = 1, 18 do
            table.insert(bricks, Brick(lastBrickX , lastBrickY , BRICK_WIDTH, 5, love.math.random(5) ))
            lastBrickX = lastBrickX + BRICK_WIDTH + 3
        end
        lastBrickX = 13
        lastBrickY = lastBrickY + 10
    end


    gameState = 'serve'

end

function love.update(dt)
    if gameState == 'serve' then

    elseif gameState == 'play' then


        if breaker:collides(player) then
            sounds['paddle_hit']:play()

            breaker.dy = -breaker.dy
            breaker.y = player.y - 10

            if breaker.dx < 0 then -- if breaker is moving left
                -- braker.dx =
                breaker.dx = math.max(-200, breaker.dx - player.dx)
                --print("breaker going left at speed: "..tostring(breaker.dx))
            else --if breaker is moving right
                breaker.dx = math.min(200, breaker.dx + player.dx)
                --print("breaker going right at speed: "..tostring(breaker.dx))
            end -- if breaker.dx < 0
        end -- if breaker:collides(player)

        for k, v in pairs(bricks) do

            if breaker:collides(bricks[k]) then
                score = score + 2
                breaker.dy = -breaker.dy
                -- breaker.y = player.y - 10
                if bricks[k]:hit() == false then
                    score = score + 5
                    table.remove(bricks, k)
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
        sounds['explosion']:play()
        lives = lives - 1
        gameState = 'serve'
        Breaker:reset(player.x + player.width/2 - 2, player.y - player.height)
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

    breaker:update(dt)

    player:update(dt)

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif
    key == 'enter' or key == 'return' then

        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            --todo reset game stuff here
        end
    end
end

function love.draw()

    -- begin rendering at virtual resolution
    push:apply('start')

    love.graphics.setFont(smallFont)
    love.graphics.setColor(255,255,255)
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to BRICK BREAKER!", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press ENTER to begin!", 0, 20, VIRTUAL_WIDTH, 'center')
    end

    player:render()
    breaker:render()

    for k, v in pairs(bricks) do
        love.graphics.setColor(bricks[k].activeColor)
        v:render()
    end

    --displayFPS()
    displayLives()
    displayScore()


    -- end rendering at virtual resolution
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayLives()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Lives: ' .. tostring(lives), 10, 10)
end

function displayScore()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Score: ' .. tostring(gameState), VIRTUAL_WIDTH - 50 , 10)
end

function love.resize(w, h)
    push:resize(w,h)
end