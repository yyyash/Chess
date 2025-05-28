--[[
    Chess by Josh Green
    4/28/2025
]]

-- initialize nearest-neighbor filter
love.graphics.setDefaultFilter('nearest', 'nearest')

-- dependencies
require 'src/Dependencies'

-- load
function love.load()
    -- window bar title
    love.window.setTitle('Chess by Josh Green')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- initialize state machine
    gStateMachine = StateMachine {
    ['menu'] = function() return MenuState() end,
    ['play'] = function() return PlayState() end,
    ['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('menu')

    -- initialize input tables
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}

    -- keep track of mouse coords
    love.mouse.x, love.mouse.y = 0


end

-- update
function love.update(dt)

    -- state machine handles game logic
    gStateMachine:update(dt)

    -- reset input handling
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

-- draw
function love.draw()
    push:start()

    -- draw background
    love.graphics.setColor(24/255, 24/255, 24/255, 1)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    gStateMachine:render()

--[[     -- print fps
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('FPS: ' .. tostring(love.timer.getFPS()), 1, 1, VIRTUAL_WIDTH, 'left') ]]

    push:finish()
end

-- input handling
function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
    love.mouse.x, love.mouse.y = push:toGame(x, y)
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end