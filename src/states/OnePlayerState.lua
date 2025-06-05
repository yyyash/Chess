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
        print('ai turn')
        local ai_legal_moves = self:getAllLegalMoves(self.board, self.turn)
        if #ai_legal_moves ~= 0 then

            -- get a random move
            local move_index = math.random(#ai_legal_moves)
            self.selectedPiece = ai_legal_moves[move_index]['piece']
            self.board:selectPiece(self.selectedPiece.gridX, self.selectedPiece.gridY)
            self.selectedGridX = ai_legal_moves[move_index]['gridX']
            self.selectedGridY = ai_legal_moves[move_index]['gridY']

            -- move the selected piece to the selected square
            -- add any taken pieces to the graveyard
            TableConcat(self.takenPieces, self:makeMove(self.board, ai_legal_moves[move_index]))

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

            -- reset selected piece and legal moves
            self.board:deselectPiece()
            self.selectedPiece = nil
        end

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
end

--[[
    chess ai function
    minimax algorithm
]]
function OnePlayerState:minimax(board, depth, isMaximizingPlayer)
    -- 1. base Cases (Terminal Nodes):
    -- if depth is 0, or if the game is over (checkmate, stalemate), evaluate the board and return the score
    if depth == 0 or isGameOver(board) then
        return evaluateBoard(board)
    end

    -- 2. Maximizing Player's Turn (AI):
    if isMaximizingPlayer then
        local bestValue = -math.huge -- Initialize with negative infinity
        local bestMove = nil

        -- Generate all possible moves for the current player
        local possibleMoves = generateAllLegalMoves(board, "AI_Color")

        for i, move in ipairs(possibleMoves) do
            -- Create a new board state by applying the move
            local newBoard = cloneBoard(board)
            applyMove(newBoard, move) -- This function modifies newBoard
            -- check end game conditions, set gameOver on the board if we have a draw or checkmate

            -- Recursively call minimax for the opponent (minimizing player)
            local value = minimax(newBoard, depth - 1, false)

            -- Update best value if current move is better
            if value > bestValue then
                bestValue = value
                bestMove = move
            end
        end
        return bestValue, bestMove -- Return the best value and the move that leads to it
    -- 3. Minimizing Player's Turn (Opponent):
    else -- isMinimizingPlayer
        local bestValue = math.huge -- Initialize with positive infinity
        local bestMove = nil

        -- Generate all possible moves for the opponent
        local possibleMoves = generateAllLegalMoves(board, "Opponent_Color")

        for i, move in ipairs(possibleMoves) do
            local newBoard = cloneBoard(board)
            applyMove(newBoard, move)

            -- Recursively call minimax for the AI (maximizing player)
            local value = minimax(newBoard, depth - 1, true)

            -- Update best value if current move is worse for AI (better for opponent)
            if value < bestValue then
                bestValue = value
                bestMove = move
            end
        end
        return bestValue, bestMove
    end
end