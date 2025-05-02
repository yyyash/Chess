--[[
    play state
]]
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.board = Board()
end

function PlayState:enter(params)
end

function PlayState:update(dt)
end

function PlayState:render()
    -- draw board
    self.board:render()
end

function PlayState:clickInBounds(x, y)
    -- give 1 pixel of buffer to prevent program from crashing when clicking on the edges
    if x < VIRTUAL_WIDTH - 271 or x > VIRTUAL_WIDTH - 17 or y < 17 or y > 271 then
        --gSounds['error']:play()
        return false
    else
        return true
    end
end    
