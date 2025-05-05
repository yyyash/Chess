--[[
    play state
]]
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.board = Board()
    self.turn = 'white'
    self.selectedGridX = 0
    self.selectedGridY = 0
    self.hasSelectedPiece = false
end

--[[ function PlayState:enter(params)
    self.board = Board()
    self.turn = 'white'
    self.selectedGridX = 0
    self.selectedGridY = 0
end ]]

function PlayState:update(dt)
    -- escape to close window
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- piece selection
    -- only select a piece if we haven't selected one
    if self.hasSelectedPiece == false then
        -- player clicked in bounds
        if love.mouse.wasPressed(1) and self:clickInBounds(love.mouse.x, love.mouse.y) then
            -- get the board grid values of the mouse click
            self.selectedGridX = math.floor((love.mouse.x - BOARD_OFFSET_X) / TILE_SIZE) + 1
            self.selectedGridY = math.floor((love.mouse.y - BOARD_OFFSET_Y) / TILE_SIZE) + 1

            -- only select the piece if it is the same color as the player turn
            if self.board:pieceColor(self.selectedGridX, self.selectedGridY) == self.turn then
                self.board:selectPiece(self.selectedGridX, self.selectedGridY)
                self.hasSelectedPiece = true
            end
        end
    -- if we have selected a piece
    -- get its legal moves and render green squares
    -- check for mouse clicks
    -- deselect if anything other than a legalMove was chosen
    -- move piece if legal move was chosen
    -- don't forget to change player turn after piece has moved
    -- take piece if legal move chosen matched with opponent's piece
    -- don't forget to change hasSelectedPiece flag
    else
        -- mouse was clicked while we have a piece selected
        if love.mouse.wasPressed(1) then
            self.board:deselectPiece()
            self.hasSelectedPiece = false
        end
    end
end

function PlayState:render()
    -- draw board
    self.board:render()
end

-- click in bounds
function PlayState:clickInBounds(x, y)
    -- give 1 pixel of buffer to prevent program from crashing when clicking on the edges
    if x < BOARD_OFFSET_X or 
        x > BOARD_OFFSET_X + (TILE_SIZE * 8) or 
        y < BOARD_OFFSET_Y or 
        y > BOARD_OFFSET_Y + (TILE_SIZE * 8) then
        --gSounds['error']:play()
        return false
    else
        return true
    end
end

-- change turns
function PlayState:changeTurns()
    if self.turn == 'white' then
        self.turn = 'black'
    else
        self.turn = 'white'
    end
end

