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
    self.moveIndex = {}
    self.allMoves = {}
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
            --print('self.selectedGrid values are ' .. self.selectedGridX .. ' , ' .. self.selectedGridY)

            -- only select the piece if it is the same color as the player turn
            if self.board:pieceColor(self.selectedGridX, self.selectedGridY) == self.turn then
                self.selectedPiece = self.board:selectPiece(self.selectedGridX, self.selectedGridY)
                -- get moves for piece clicked on
                self.legalMoves = self:getLegalMoves()
                -- in order for these moves to be legal, they cannot put the current turn in check
                -- 
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
        -- calculate moves for selected piece
        --self.legalMoves = self.board:getMoves(self.selectedPiece)
        --local getMoves = self.board:getMoves(self.selectedPiece)

        -- check if any of these moves result with the player in check, remove those moves from legalMoves
        -- iterate through getMoves table
        -- make each move, be sure to get piece info if a piece is taken
        -- local takenPiece = {}
        -- get check info against ourself, if we are in check, do not add this move to the return table
        -- reset pieces to original positions (insert taken pieces back into the board table)

        -- mouse was clicked while we have a piece selected
        if love.mouse.wasPressed(1) then
            -- check if we clicked on a legalMove
            self.selectedGridX, self.selectedGridY = self:clickToGrid(love.mouse.x, love.mouse.y)

            if self.legalMoves ~= nil and self:legalMoveSelected() then
                
                self.moveIndex = self:getMoveIndex()

                -- if there is a piece on this square and its a different color, take it
                if self.board:emptySquare(self.selectedGridX, self.selectedGridY) == false and self.board:pieceColor(self.selectedGridX, self.selectedGridY) ~= self.selectedPiece.color then
                    self.board:takePiece(self.selectedGridX, self.selectedGridY)
                end

                -- move the selected piece to the selected square
                self:makeMove(self.legalMoves[self.moveIndex])

                -- set check if we put the opponent in check
                -- reset check if we moved to protect the king
                self:setCheck()

                -- change turns, current move is over
                self:changeTurns()    

                -- reset all moves since a piece just moved
                self.allMoves = {}

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

--[[
    sets enPassant
    takes a piece en passant
    moves the rook for castling
    moves selected piece to selected square
    resets en passant flag if not taken
    promotes pawns
]]
function PlayState:makeMove(move)
    -- set piece values for the special cases of moves: en passant, castling, pawn promotion
    -- uses flags set in the moves table during move generation

    -- set the enPassantFlag if pawn first moved to an adjecent enemy pawn
    if move['triggersEnPassant'] then
        self.board:setEnPassant(self.selectedPiece)

    -- take the pawn by en passant
    elseif move['enPassantTake'] then
        -- check if en passant piece is above
        if self.board:checkEnPassant(move['gridX'], move['gridY'] + 1) then
            self.board:takePiece(move['gridX'], move['gridY'] + 1)
        -- check if en passant piece is below
        elseif self.board:checkEnPassant(move['gridX'], move['gridY'] - 1) then
            self.board:takePiece(move['gridX'], move['gridY'] - 1)
        end

    -- castle right
    elseif move['castleRight'] then
        for i = 1, #self.board.pieces do
            -- find the rook to the right of the selected king
            if self.board.pieces[i].gridX == self.selectedPiece.gridX + 3 and self.board.pieces[i].gridY == self.selectedPiece.gridY and self.board.pieces[i].pieceType == 'rook' then
                -- move the rook 1 square to the right of the selected king
                self.board.pieces[i]:moveTo(self.selectedPiece.gridX + 1, self.selectedPiece.gridY)
            end
        end

    -- castle left
    elseif move['castleLeft'] then
        for i = 1, #self.board.pieces do
            -- find the rook to the left of the selected king
            if self.board.pieces[i].gridX == self.selectedPiece.gridX - 4 and self.board.pieces[i].gridY == self.selectedPiece.gridY and self.board.pieces[i].pieceType == 'rook' then
                -- move the rook 2 squares to the left of the selected king
                self.board.pieces[i]:moveTo(self.selectedPiece.gridX - 2, self.selectedPiece.gridY)
            end
        end
    end

    -- move the piece to the selected square
    for i = 1, #self.board.pieces do
        if self.board.pieces[i].isSelected then
            self.board.pieces[i]:moveTo(self.selectedGridX, self.selectedGridY)

            -- if player 1 just moved and player 2 had an enPassant pawn, reset the enPassant flag
            if self.board:enPassantColor() ~= nil and self.board:enPassantColor() ~= self.turn then
                self.board:resetEnPassant()

            -- pawn promotion
            elseif self.board.pieces[i].pieceType == 'pawn' and self.board.pieces[i].gridY == 1 and self.turn == 'white' then
                self.board.pieces[i].pieceType = 'queen'
                self.board.pieces[i].tileID = WHITE_QUEEN

            elseif self.board.pieces[i].pieceType == 'pawn' and self.board.pieces[i].gridY == 8 and self.turn == 'black' then
                self.board.pieces[i].pieceType = 'queen'
                self.board.pieces[i].tileID = BLACK_QUEEN
            end
        end
    end
end

--[[
    returns the index of the move chosen from the legalMoves table
]]
function PlayState:getMoveIndex()
    for i = 1, #self.legalMoves do
        if self.selectedGridX == self.legalMoves[i]['gridX'] and self.selectedGridY == self.legalMoves[i]['gridY'] then
            return i
        end
    end
end

--[[
    returns true if a legal move was selected
]]
function PlayState:legalMoveSelected()
    for i = 1, #self.legalMoves do
        if self.selectedGridX == self.legalMoves[i]['gridX'] and self.selectedGridY == self.legalMoves[i]['gridY'] then
            return true
        end
    end
    
    -- if we made it here, a legal move was not selected
    return false
end

--[[
    sets check as appropriate after a move has happened
]]
function PlayState:setCheck()
    -- move the selected piece to the selected square
    self:makeMove(self.legalMoves[self.moveIndex])

    -- now that the player has moved, grab all the new moves for that player
    self.allMoves = self.board:getAllMoves(self.turn)
    
    -- look for check on the opposing player and set check on the opposing king
    self:changeTurns()
    if self.board:getCheck(self.turn, self.allMoves) then
        self.board:setCheck(self.turn)
    end

    -- reset check if we just moved to protect the king
    self.allMoves = {}
    self.allMoves = self.board:getAllMoves(self.turn)

    -- change turns to look at our own check status
    self:changeTurns()
    if self.board:getCheck(self.turn, self.allMoves) == false then
        self.board:resetCheck(self.turn)
    else
        -- we just moved ourself into check, not legal, we should never get here
        self.board:setCheck(self.turn)
        -- debug
        print('shit is fucked up yo')
    end

    self.allMoves = {}
end

--[[
    gets the legal moves for the current turn
    legal means they cannot put the current turn in check
    returns a table of legal moves
]]
function PlayState:getLegalMoves()
    -- this gets all of the possible moves for the currently selected piece
    local moves = self.board:getMoves(self.selectedPiece)
    local legalMoves = {}
    local opponentsMoves = {}
    local tempPiece = {}
    local tempPieceIndex = 0
    local pieceRemoved = false
    -- save a copy of all of the pieces so we can reset after making moves
    -- this does not work, going to have to copy the piece's data manually and if we take a piece I need to copy that and its index so it can be replaced
    -- save a copy of the selectedGridX and selectedGridY for making moves
    local pieceGridX = self.selectedPiece.gridX
    local pieceGridY = self.selectedPiece.gridY

--[[     if moves == nil then
        return nil
    end ]]

    -- for each of these moves
    -- make the move
    -- look if current turn is in check
    -- if yes, move is not legal
    -- if no, move is legal, add to legalMoves table
    for i = 1, #moves do

        -- move the selected piece
        self.selectedPiece.gridX = moves[i]['gridX']
        self.selectedPiece.gridY = moves[i]['gridY']

        -- check if there is an enemy piece where we just fake-moved to
        if self.board:oppColor(moves[i]['gridX'], moves[i]['gridY'], self.selectedPiece) then
            for j = 1, #self.board.pieces do
                -- found the piece
                if self.board.pieces[j].gridX == moves[i]['gridX'] and self.board.pieces[j].gridY == moves[i]['gridY'] then
                    tempPiece = self.board.pieces[j]
                    tempPieceIndex = j
                    break
                end
            end
            table.remove(self.board.pieces, tempPieceIndex)
            pieceRemoved = true
        end

        

        -- change turn to get opponents moves
        self:changeTurns()
        opponentsMoves = self.board:getAllMoves(self.turn)
        self:changeTurns()

        -- look for check on current turn using all of the opponents moves
        -- if this is false, then this move is legal, add it to the table
        if self.board:getCheck(self.turn, opponentsMoves) == false then
            table.insert(legalMoves, moves[i])
        end

        -- reset opponentsMoves table before going to the next move
        opponentsMoves = {}

        -- reset piece grid values before going to the next move
        self.selectedPiece.gridX = pieceGridX
        self.selectedPiece.gridY = pieceGridY

        -- reinsert piece back into table if removed
        if pieceRemoved then
            table.insert(self.board.pieces, tempPieceIndex, tempPiece)
            pieceRemoved = false
        end

    end
    -- done checking all of the current pieces moves, should be left with only legal moves now
    return legalMoves
end