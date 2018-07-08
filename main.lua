--
-- User: Tanner Brown
-- Date: 7/4/2018
--
Class = require 'class'
push = require 'push'
require 'Brick'
require 'Paddle'
require 'Breaker'
require 'Upgrade'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ServeState'
require 'states/TitleState'
require 'states/GameOverState'
require 'StateMachine'
-- Constant Variables
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PLAYER_SPEED = 200
BLUE = { 0, 0, 128 }
RED = {255, 0, 0 }
GREEN = { 0, 128, 0 }
PURPLE = {51, 0, 102 }
YELLOW = {255, 255, 0}

gStateMachine = {}
gFonts = {}
gBricks = {}
player = {}
breaker = {}
sounds = {}
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Brick Breaker!!")

    -- RNG seed
    math.randomseed(os.time())

    -- fonts
    gFonts = {
        ['small'] = love.graphics.newFont('assets/font.ttf', 8),
        ['large'] = love.graphics.newFont('assets/font.ttf', 16),
        ['huge'] = love.graphics.newFont('assets/font.ttf', 24), --different fonts, because a font object is immutable
    }
    love.graphics.setFont(gFonts['small'])

    --table of sounds
    sounds = {
        ['paddle_hit'] = love.audio.newSource('assets/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('assets/score.wav', 'static'),
        ['brick_hit'] = love.audio.newSource('assets/wall_hit.wav', 'static'),
        ['explosion'] = love.audio.newSource('assets/explosion.wav', 'static'),
        ['upgrade'] = love.audio.newSource('assets/powerup.wav', 'static'),
        ['music'] = love.audio.newSource('assets/music.mp3', 'static')
    }
    --[[
    MUSIC PROVIDED BY:
    https://freesound.org/people/jammerboy70/sounds/398640/
     ]]
    sounds['music']:setLooping(true)
    sounds['music']:play()

    --table of stateMachines
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['serve'] = function() return ServeState() end,
        ['play'] = function() return PlayState() end,
        ['gameover'] = function() return GameOverState() end
    }

    gStateMachine:change('title')


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true --syncs with screen refresh rate
    })


    --activeState = 'serve'

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

    gScore = 0
    gLives = 3
    player = Paddle(VIRTUAL_WIDTH / 2 , VIRTUAL_HEIGHT - 10 , 40, 5)
    breaker = Breaker(player.x + player.width/2 - 2, player.y - player.height, 3, 4)

    --create the upgrade object
    gUpgrade = Upgrade(-50, -50)


end

function love.update(dt)

    gStateMachine:update(dt)
    if gUpgrade.active == true then
        gUpgrade:update(dt)
    end


end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()

    -- begin rendering at virtual resolution
    push:start()

    gStateMachine:render()

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(255,255,255)
    --displayFPS()
    displayLives()
    displayScore()
    if gUpgrade.active == true then
        gUpgrade:render()
    end


    -- end rendering at virtual resolution
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayLives()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Lives: ' .. tostring(gLives), 10, 10)
end

function displayScore()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Score: ' .. tostring(gScore), VIRTUAL_WIDTH - 50 , 10)
end

function love.resize(w, h)
    push:resize(w,h)
end