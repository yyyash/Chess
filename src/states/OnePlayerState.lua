--[[
    1 Player State
    Human player (Player 1) plays against Chess Bot (AI)
]]
OnePlayerState = Class{__includes = PlayState}

function OnePlayerState:update(dt)
    -- escape to close window
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.turn ~= self.p1_color then
        -- AI logic goes here
        -- legal moves

        -- deal with checkmate later
        print('ai turn')
        local ai_legal_moves = self:getAllLegalMoves(self.turn)
        if #ai_legal_moves ~= 0 then

            -- get a random move
            local move_index = math.random(#ai_legal_moves)
            self.selectedPiece = ai_legal_moves[move_index]['piece']
            self.board:selectPiece(self.selectedPiece.gridX, self.selectedPiece.gridY)
            self.selectedGridX = ai_legal_moves[move_index]['gridX']
            self.selectedGridY = ai_legal_moves[move_index]['gridY']

            -- if there is a piece on this square and its a different color, take it
            if self.board:emptySquare(self.selectedGridX, self.selectedGridY) == false and self.board:pieceColor(self.selectedGridX, self.selectedGridY) ~= self.selectedPiece.color then
                table.insert(self.takenPieces, { 
                    ['piece_color'] = self.board:pieceColor(self.selectedGridX, self.selectedGridY), 
                    ['piece_type'] = self.board:pieceType(self.selectedGridX, self.selectedGridY)
                })
                self.board:takePiece(self.selectedGridX, self.selectedGridY)
            end

            -- move the selected piece to the selected square
            self:makeMove(ai_legal_moves[move_index])

            -- set check if we put the opponent in check
            -- reset check if we moved to protect the king
            self:setCheck()

            -- look for checkmate
            self:checkMate(self:getOppTurn())
            self:changeTurns()

            -- reset selected piece and legal moves
            self.board:deselectPiece()
            self.selectedPiece = nil
        end
    else
        -- player 1 input
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
                    self.legalMoves = self:getLegalMoves(self.selectedPiece)
                end
            end

        -- mouse was clicked while we have a piece selected
        else
            if love.mouse.wasPressed(1) then
                -- check if we clicked on a legalMove
                self.selectedGridX, self.selectedGridY = self:clickToGrid(love.mouse.x, love.mouse.y)

                if self.legalMoves ~= nil and self:legalMoveSelected() then
                    
                    self.moveIndex = self:getMoveIndex()

                    -- if there is a piece on this square and its a different color, take it
                    if self.board:emptySquare(self.selectedGridX, self.selectedGridY) == false and self.board:pieceColor(self.selectedGridX, self.selectedGridY) ~= self.selectedPiece.color then
                        table.insert(self.takenPieces, { 
                            ['piece_color'] = self.board:pieceColor(self.selectedGridX, self.selectedGridY), 
                            ['piece_type'] = self.board:pieceType(self.selectedGridX, self.selectedGridY)
                        })
                        self.board:takePiece(self.selectedGridX, self.selectedGridY)
                    end

                    -- move the selected piece to the selected square
                    self:makeMove(self.legalMoves[self.moveIndex])

                    -- set check if we put the opponent in check
                    -- reset check if we moved to protect the king
                    self:setCheck()

                    -- look for checkmate
                    self:checkMate(self:getOppTurn())
                    self:changeTurns()
                end

                -- reset selected piece and legal moves
                self.board:deselectPiece()
                self.selectedPiece = nil
                self.legalMoves = {}
            end
        end
    end
end