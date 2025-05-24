--[[
    Loads in textures and sounds and stores them
    Dump all require statements here
]]

-- libraries
Class = require 'lib/class'
push = require 'lib/push'

-- utility
require 'src/StateMachine'
require 'src/Util'
require 'src/constants'

-- classes
require 'src/Board'
require 'src/Piece'
require 'src/Button'

-- states
require 'src/states/BaseState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/MenuState'

-- load in sounds
gSounds = {}

-- load in sprite sheet
gTextures = {
    ['assets'] = love.graphics.newImage('graphics/chess.png')
}

-- parse through sprite sheet
gFrames = {
    -- all pieces are same size so just quad the whole thing and index as needed
    ['pieces'] = GenerateQuads(gTextures['assets'], 32, 32),

    -- 2 by 2 section of the board
    ['boardQuad'] = love.graphics.newQuad(16, 176, 64, 64, gTextures['assets']:getDimensions()),

    -- border corners
    ['top_left_border'] = love.graphics.newQuad(0, 160, 16, 16, gTextures['assets']:getDimensions()),
    ['top_right_border'] = love.graphics.newQuad(80, 160, 16, 16, gTextures['assets']:getDimensions()),
    ['bottom_left_border'] = love.graphics.newQuad(0, 240, 16, 16, gTextures['assets']:getDimensions()),
    ['bottom_right_border'] = love.graphics.newQuad(80, 240, 16, 16, gTextures['assets']:getDimensions()),

    -- border sides
    ['left_border'] = love.graphics.newQuad(0, 176, 16, 64, gTextures['assets']:getDimensions()),
    ['right_border'] = love.graphics.newQuad(80, 176, 16, 64, gTextures['assets']:getDimensions()),
    ['top_border'] = love.graphics.newQuad(16, 160, 64, 16, gTextures['assets']:getDimensions()),
    ['bottom_border'] = love.graphics.newQuad(16, 240, 64, 16, gTextures['assets']:getDimensions())
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/m6x11.ttf', 16),
    ['medium'] = love.graphics.newFont('fonts/m6x11.ttf', 32),
    ['large'] = love.graphics.newFont('fonts/m6x11.ttf', 48)
}