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

    -- AI turn
    if self.turn ~= self.p1_color then

        local bestScore, bestMove = self:minimax(self.board, 1, true)
        print('best eval was ' .. bestScore)

        -- move the selected piece to the selected square
        -- add any taken pieces to the graveyard
        if bestMove then
            -- need to select the piece in order to move it
            TableConcat(self.takenPieces, self.board:makeMove(bestMove))
            print('best move was ' .. bestMove['gridX'] .. ' , ' .. bestMove['gridY'])

            -- check game over conditions
            self.gameOverType = self:gameOver(self.board, self:getOppTurn())
            -- look for gameover
            if self.gameOverType == 'checkmate' then
                gStateMachine:change('game_over', { board = self.board, gameOverType = self.gameOverType, winner = self.turn, buttons = self.buttons})
            elseif self.gameOverType == 'stalemate' then
                gStateMachine:change('game_over', { board = self.board, gameOverType = self.gameOverType, winner = '', buttons = self.buttons})
            else
                self:changeTurns()
                print('turn changed, no game over detected')
            end

        else
            print('ai found no legal moves, we shouldnt get here')
        end

        -- reset selected piece and legal moves
        self.board:deselectPiece()
        self.selectedPiece = nil
        

    -- player 1 turn
    else

        -- piece selection
        -- only select a piece if we haven't selected one and there is no checkmate
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
                    
                    -- move the selected piece to the selected square
                    self.moveIndex = self:getMoveIndex()

                    -- move the selected piece to the selected square
                    -- add any taken pieces to the graveyard
                    TableConcat(self.takenPieces, self.board:makeMove(self.legalMoves[self.moveIndex]))

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
end

--[[
    chess ai function
    minimax algorithm
]]
function OnePlayerState:minimax(board, depth, isMaximizingPlayer)
    -- 1. if depth is 0, or if the game is over (checkmate, stalemate), evaluate the board and return the score
    if depth == 0 or board.checkmate ~= '' or board.stalemate then
        --print(board:eval())
        return board:eval()
    end

    -- 2. maximizing ai turn
    if isMaximizingPlayer then
        local bestValue = -math.huge
        local bestMove = nil

        -- generate all possible moves for the ai
        local possibleMoves = self:getAllLegalMoves(board, self.p2_color)
        --print(#possibleMoves)

        for i, move in ipairs(possibleMoves) do
            -- create a new board state and apply the move
            local newBoard = board:clone()

            -- make the move on the new board
            newBoard:makeMove(move)

            -- check end game conditions, sets checkmate or stalemate on the board (for eval function)
            self:gameOver(newBoard, self.p1_color)

            -- recursively call minimax for player 1 (minimizing player)
            local value = self:minimax(newBoard, depth - 1, false)

            -- update best value if current move is better
            if value >= bestValue then
                bestValue = value
                bestMove = move
                print(bestValue)
                --print(bestMove['gridX'] .. ' , ' .. bestMove['gridY'])
            end
        end

        --print(bestMove['gridX'] .. ' , ' .. bestMove['gridY'])
        return bestValue, bestMove -- return the best value and the move that leads to it

    -- 3. minimizing player 1 turn (human)
    else -- isMinimizingPlayer
        local bestValue = math.huge
        local bestMove = nil

        -- generate all possible moves for the opponent
        local possibleMoves = self:getAllLegalMoves(board, self.p1_color)

        for i, move in ipairs(possibleMoves) do
            -- create a new board state and apply the move
            local newBoard = board:clone()

            -- make the move on the new board
            newBoard:makeMove(move)

            -- check end game conditions, sets checkmate or stalemate on the board (for eval function)
            if self:gameOver(newBoard, self.p2_color) then
                isGameOver = true
            end

            -- recursively call minimax for the ai (maximizing player)
            local value = self:minimax(newBoard, depth - 1, true)

            -- update best value if current move is worse for AI (better for opponent)
            if value <= bestValue then
                bestValue = value
                bestMove = move
            end
        end

        return bestValue, bestMove
    end
end