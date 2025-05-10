--[[
    play state
]]
PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.board = Board()
    self.turn = 'white'
    self.selectedGridX = 0
    self.selectedGridY = 0
    self.selectedPiece = nil
    self.legalMoves = {}
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
    if self.selectedPiece == nil then
        -- player clicked in bounds
        if love.mouse.wasPressed(1) and self:clickInBounds(love.mouse.x, love.mouse.y) then
            -- get the board grid values of the mouse click
            self.selectedGridX = math.floor((love.mouse.x - BOARD_OFFSET_X) / TILE_SIZE) + 1
            self.selectedGridY = math.floor((love.mouse.y - BOARD_OFFSET_Y) / TILE_SIZE) + 1

            -- only select the piece if it is the same color as the player turn
            if self.board:pieceColor(self.selectedGridX, self.selectedGridY) == self.turn then
                self.selectedPiece = self.board:selectPiece(self.selectedGridX, self.selectedGridY)
            end
        end

    -- if we have selected a piece
    -- get its legal moves
    -- check for mouse clicks
    -- deselect if anything other than a legalMove was chosen
    -- move piece if legal move was chosen
    -- change player turn after piece has moved

    -- take piece if legal move chosen matched with opponent's piece
    else
        -- calculate legal moves for selected piece
        self.legalMoves = self.board:legalMoves(self.selectedPiece)

        -- mouse was clicked while we have a piece selected
        if love.mouse.wasPressed(1) then
            -- check if we clicked on a legalMove
            self.selectedGridX, self.selectedGridY = self:clickToGrid(love.mouse.x, love.mouse.y)
            if self.legalMoves ~= nil then
                for i = 1, #self.legalMoves do
                    if self.selectedGridX == self.legalMoves[i]['gridX'] and self.selectedGridY == self.legalMoves[i]['gridY'] then
                        -- clicked on a legal move
                        -- if there is a piece on this square, take it
                        if self.board:emptySquare(self.selectedGridX, self.selectedGridY) == false then
                            self.board:takePiece(self.selectedGridX, self.selectedGridY)
                        -- set the enPassantFlag if pawn first moved to an adjecent enemy pawn
                        elseif self.legalMoves[i]['triggersEnPassant'] then
                            self.board:setEnPassant(self.selectedPiece)
                        end
                        -- take the pawn by en passant
                        if self.legalMoves[i]['enPassantTake'] then
                            -- check if en passant piece is above
                            if self.board:checkEnPassant(self.legalMoves[i]['gridX'], self.legalMoves[i]['gridY'] + 1) then
                                self.board:takePiece(self.legalMoves[i]['gridX'], self.legalMoves[i]['gridY'] + 1)
                            -- check if en passant piece is below
                            elseif self.board:checkEnPassant(self.legalMoves[i]['gridX'], self.legalMoves[i]['gridY'] - 1) then
                                self.board:takePiece(self.legalMoves[i]['gridX'], self.legalMoves[i]['gridY'] -1)
                            end
                        end
                        -- move the piece to the selected square
                        for i = 1, #self.board.pieces do
                            if self.board.pieces[i].isSelected then
                                self.board.pieces[i]:moveTo(self.selectedGridX, self.selectedGridY)
                                -- if player 1 just moved and player 2 had an enPassant pawn, reset the enPassant flag
                                if self.board:enPassantColor() ~= nil and self.board:enPassantColor() ~= self.turn then
                                    self.board:resetEnPassant()
                                end
                                -- change turns since we just moved
                                self:changeTurns()
                            end
                        end
                    end
                end
            end
            -- reset selected piece and legal moves
            self.board:deselectPiece()
            self.selectedPiece = nil
            self.legalMoves = {}
        end
    end
end

function PlayState:render()
    -- draw board
    self.board:render()
    if self.legalMoves ~= nil then
        -- render legal move indicators
        for i = 1, #self.legalMoves do
            love.graphics.setColor(0, 247/255, 0, .8)
            love.graphics.circle('fill', 
                (self.legalMoves[i]['gridX'] - 1) * TILE_SIZE + BOARD_OFFSET_X + (TILE_SIZE/2), 
                (self.legalMoves[i]['gridY'] - 1) * TILE_SIZE + BOARD_OFFSET_Y + (TILE_SIZE/2), 
                6)
        end
    end
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

-- convert mouse to gridX, gridY
function PlayState:clickToGrid(x , y)
    -- get the board grid values of the mouse click
    return math.floor((x - BOARD_OFFSET_X) / TILE_SIZE) + 1, math.floor((y - BOARD_OFFSET_Y) / TILE_SIZE) + 1
end
-- legal move clicked
-- return gridX, gridY of legal move clicked
-- return 0, 0 if 

-- change turns
function PlayState:changeTurns()
    if self.turn == 'white' then
        self.turn = 'black'
    else
        self.turn = 'white'
    end
end

