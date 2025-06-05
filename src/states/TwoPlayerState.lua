--[[
    2 Player Game mode
    Player controls both sides
]]
TwoPlayerState = Class{__includes = PlayState}

--[[
    copied straight out of PlayState, init, render, update, ect, will use PlayState's version
]]
function TwoPlayerState:update(dt)

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
                -- get moves for piece clicked on
                self.legalMoves = self:getLegalMoves(self.board, self.selectedPiece)
            end
        end

    -- mouse was clicked while we have a piece selected
    else
        if love.mouse.wasPressed(1) then
            -- check if we clicked on a legalMove
            self.selectedGridX, self.selectedGridY = self:clickToGrid(love.mouse.x, love.mouse.y)

            if self.legalMoves ~= nil and self:legalMoveSelected() then
                
                self.moveIndex = self:getMoveIndex()

                -- move the selected piece to the selected square
                -- add any taken pieces to the graveyard
                TableConcat(self.takenPieces, self:makeMove(self.board, self.legalMoves[self.moveIndex]))

                -- check game over conditions
                self.gameOverType = self:gameOver(self.board, self:getOppTurn())
                -- look for gameover
                if self.gameOverType == 'checkmate' then
                    gStateMachine:change('game_over', { board = self.board, gameOverType = self.gameOverType, winner = self.turn, buttons = self.buttons})
                elseif self.gameOverType == 'stalemate' then
                    gStateMachine:change('game_over', { board = self.board, gameOverType = self.gameOverType, winner = '', buttons = self.buttons})
                else
                    self:changeTurns()
                end
            end

            -- reset selected piece and legal moves
            self.board:deselectPiece()
            self.selectedPiece = nil
            self.legalMoves = {}
        end
    end
end

