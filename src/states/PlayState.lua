--[[
    play state
]]
PlayState = Class{__includes = BaseState}

function PlayState:enter(params)
    self.board = Board(params.p1_color)
    self.p1_color = params.p1_color
    self.p2_color = self:getOppColor(self.p1_color)
    self.turn = 'white'
    self.selectedGridX = 0
    self.selectedGridY = 0
    self.selectedPiece = nil
    self.legalMoves = {}
    self.moveIndex = {}
    self.allMoves = {}
    self.gameOverType = ''

    self.buttons = {}
    table.insert(self.buttons, Button('home', 'play', function() gStateMachine:change('menu') end))
    table.insert(self.buttons, Button('restart', 'play', function() self:enter({p1_color = self.p1_color}) end))

    self.button_margin = 5

    self.takenPieces = {}
end

function PlayState:render()
    -- draw board
    self.board:render()

    -- render legal moves green circles
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

    self:renderUI()
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

-- change turns
function PlayState:changeTurns()
    if self.turn == 'white' then
        self.turn = 'black'
    else
        self.turn = 'white'
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
    gets the legal moves for a piece
    legal means the move cannot put the current turn in check
    returns a table of legal moves
]]
function PlayState:getLegalMoves(board, piece)
    -- this gets all of the possible moves for the currently selected piece
    local moves = board:getMoves(piece)
    local legalMoves = {}
    local opponentsMoves = {}
    local opponentsColor = board:getOppColor(piece)
    local tempPiece = {}
    local tempPieceIndex = 0
    local pieceRemoved = false
    -- save a copy of the original piece position to move back later
    local pieceGridX = piece.gridX
    local pieceGridY = piece.gridY

    -- for each of these moves
    -- make the move
    -- look if current turn is in check
    -- if yes, move is not legal
    -- if no, move is legal, add to legalMoves table
    for i = 1, #moves do

        -- edge case where king cannot castle if any of the squares on the way to castling are under attack
        if moves[i]['castleRight'] then
            -- check if the square to the right is being attacked
            -- change turn to get opponents moves
            opponentsMoves = board:getAllMoves(opponentsColor)

            for j = 1, #opponentsMoves do
                if opponentsMoves[j]['gridX'] == piece.gridX + 1 and opponentsMoves[j]['gridY'] == piece.gridY then
                    goto continue
                end
            end
        elseif moves[i]['castleLeft'] then
            -- check if any of the two squares to the left are being attacked
            -- change turn to get opponents moves
            opponentsMoves = board:getAllMoves(opponentsColor)

            for j = 1, #opponentsMoves do
                if opponentsMoves[j]['gridX'] == piece.gridX - 1 and opponentsMoves[j]['gridY'] == piece.gridY then
                    goto continue
                elseif opponentsMoves[j]['gridX'] == piece.gridX - 2 and opponentsMoves[j]['gridY'] == piece.gridY then
                    goto continue
                end
            end
        end

        -- check if there is an enemy piece where we are about to fake-move to
        if board:oppColor(moves[i]['gridX'], moves[i]['gridY'], piece) then
            for j = 1, #board.pieces do
                -- found the piece
                if board.pieces[j].gridX == moves[i]['gridX'] and board.pieces[j].gridY == moves[i]['gridY'] then
                    tempPiece = board.pieces[j]
                    tempPieceIndex = j
                    break
                end
            end
            table.remove(board.pieces, tempPieceIndex)
            pieceRemoved = true
        end

        -- fake-move the selected piece
        piece.gridX = moves[i]['gridX']
        piece.gridY = moves[i]['gridY']

        -- get opponents moves
        opponentsMoves = board:getAllMoves(opponentsColor)

        -- look for check on current turn using all of the opponents moves
        -- if this is false, then this move is legal, add it to the table
        if board:getCheck(piece.color, opponentsMoves) == false then
            table.insert(legalMoves, moves[i])
        end

        ::continue::
        -- reset opponentsMoves table before going to the next move
        opponentsMoves = {}

        -- reset piece grid values before going to the next move
        piece.gridX = pieceGridX
        piece.gridY = pieceGridY

        -- reinsert piece back into table if removed
        if pieceRemoved then
            table.insert(board.pieces, tempPieceIndex, tempPiece)
            pieceRemoved = false
        end
    end
    -- done checking all of the current pieces moves, should be left with only legal moves now
    return legalMoves
end

--[[
    get all legal moves for a color
    returns a table of all legal moves
]]
function PlayState:getAllLegalMoves(board, color)
    local allLegalMoves = {}
    for i = 1, #board.pieces do
        if board.pieces[i].color == color then
            TableConcat(allLegalMoves, self:getLegalMoves(board, board.pieces[i]))
        end
    end
    return allLegalMoves
end

--[[
    return true and a string for game over type
    'checkmate'
    'stalemate'
    other conditions to add later
]]
function PlayState:gameOver(board, color)
    if self:checkMate(board, color) then
        board.checkmate = self:getOppColor(color)
        return 'checkmate'
    elseif self:staleMate(board, color) then
        board.stalemate = true
        return 'stalemate'
    end
    return ''
end

--[[
    looks for checkmate on the color
    returns true for checkmate, false otherwise
]]
function PlayState:checkMate(board, color)
    local allLegalMoves = self:getAllLegalMoves(board, color)
    if #allLegalMoves == 0 and board:inCheck(color) then
        return true
    else
        return false
    end
end

--[[
    if the color has no legal moves, but is not in check, stalemate
]]
function PlayState:staleMate(board, color)
    local allLegalMoves = self:getAllLegalMoves(board, color)
    if #allLegalMoves == 0 and board:inCheck(color) == false then
        return true
    else
        return false
    end
end

--[[
    One big ugly place for all the UI elements
]]
function PlayState:renderUI()
        -- buttons
    for i, button in ipairs(self.buttons) do 
        button:render(( i - 1) * (PLAY_BUTTON_WIDTH + self.button_margin) + 5, 5)
    end

    -- writes who is in check at the top of the screen
    love.graphics.setFont(gFonts['small'])
    if self.board:inCheck(self.turn) and self.checkmate == false then
        if self.turn == 'white' then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf('White is in check', 0, 13, VIRTUAL_WIDTH, 'center')
        else
            -- text border
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf('Black is in check', 1, 13, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black is in check', -1, 13, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black is in check', 0, 14, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black is in check', 0, 12, VIRTUAL_WIDTH, 'center')

            -- text
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.printf('Black is in check', 0, 13, VIRTUAL_WIDTH, 'center')
        end

    -- writes who's turn it is
    else
        if self.turn == 'white' then
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf('White to move', 0, 13, VIRTUAL_WIDTH, 'center')
        else
            -- text border
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf('Black to move', 1, 13, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black to move', -1, 13, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black to move', 0, 14, VIRTUAL_WIDTH, 'center')
            love.graphics.printf('Black to move', 0, 12, VIRTUAL_WIDTH, 'center')

            -- text
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.printf('Black to move', 0, 13, VIRTUAL_WIDTH, 'center')
        end
    end

    -- pieces taken ui
    -- draw headers
    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('White', 0, 40, BOARD_OFFSET_X - 16, 'center')
    -- black
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Black', BOARD_OFFSET_X + 33, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Black', BOARD_OFFSET_X + 31, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Black', BOARD_OFFSET_X + 32, 41, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Black', BOARD_OFFSET_X + 32, 39, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf('Black', BOARD_OFFSET_X + 32, 40, VIRTUAL_WIDTH, 'center')

    local cursor_w_pawn = TAKEN_PIECES_W_START
    local cursor_w_knight = TAKEN_PIECES_W_START
    local cursor_w_bishop = TAKEN_PIECES_W_START + TILE_SIZE * 1.5
    local cursor_w_rook = TAKEN_PIECES_W_START
    local cursor_w_queen = TAKEN_PIECES_W_START + TILE_SIZE * 1.5

    local cursor_b_pawn = TAKEN_PIECES_B_START
    local cursor_b_knight = TAKEN_PIECES_B_START
    local cursor_b_bishop = TAKEN_PIECES_B_START + TILE_SIZE * 1.5
    local cursor_b_rook = TAKEN_PIECES_B_START
    local cursor_b_queen = TAKEN_PIECES_B_START + TILE_SIZE * 1.5

    local pawn_y = PAWN_Y_START
    local knights_bishops_y = pawn_y + 37
    local rooks_queens_y = knights_bishops_y + 37

    for i = 1, #self.takenPieces do
        love.graphics.setColor(1, 1, 1, 1)
        -- draw taken pieces (white)
        if self.takenPieces[i]['piece_color'] == 'white' then

            if self.takenPieces[i]['piece_type'] == 'pawn' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][WHITE_PAWN], cursor_w_pawn, pawn_y)
                cursor_w_pawn = cursor_w_pawn + 10

            elseif self.takenPieces[i]['piece_type'] == 'knight' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][WHITE_KNIGHT], cursor_w_knight, knights_bishops_y)
                cursor_w_knight = cursor_w_knight + 10

            elseif self.takenPieces[i]['piece_type'] == 'bishop' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][WHITE_BISHOP], cursor_w_bishop, knights_bishops_y)
                cursor_w_bishop = cursor_w_bishop + 10

            elseif self.takenPieces[i]['piece_type'] == 'rook' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][WHITE_ROOK], cursor_w_rook, rooks_queens_y)
                cursor_w_rook = cursor_w_rook + 10

            elseif self.takenPieces[i]['piece_type'] == 'queen' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][WHITE_QUEEN], cursor_w_queen, rooks_queens_y)
                cursor_w_queen = cursor_w_queen + 10
            end

        -- draw taken pieces (Black)
        else

            if self.takenPieces[i]['piece_type'] == 'pawn' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][BLACK_PAWN], cursor_b_pawn, pawn_y)
                cursor_b_pawn = cursor_b_pawn + 10

            elseif self.takenPieces[i]['piece_type'] == 'knight' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][BLACK_KNIGHT], cursor_b_knight, knights_bishops_y)
                cursor_b_knight = cursor_b_knight + 10

            elseif self.takenPieces[i]['piece_type'] == 'bishop' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][BLACK_BISHOP], cursor_b_bishop, knights_bishops_y)
                cursor_b_bishop = cursor_b_bishop + 10

            elseif self.takenPieces[i]['piece_type'] == 'rook' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][BLACK_ROOK], cursor_b_rook, rooks_queens_y)
                cursor_b_rook = cursor_b_rook + 10

            elseif self.takenPieces[i]['piece_type'] == 'queen' then
                love.graphics.draw(gTextures['assets'], gFrames['pieces'][BLACK_QUEEN], cursor_b_queen, rooks_queens_y)
                cursor_b_queen = cursor_b_queen + 10
            end

        end
    end

    -- draw material difference under piece graveyard
    local material_difference = self.board:materialDifference()
    love.graphics.setFont(gFonts['medium'])

    -- white is ahead
    if material_difference > 0 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), 0, 220, BOARD_OFFSET_X - 16, 'center')

    -- black is ahead
    elseif material_difference < 0 then
    -- text border
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), BOARD_OFFSET_X + 31, 220, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), BOARD_OFFSET_X + 33, 220, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), BOARD_OFFSET_X + 32, 221, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), BOARD_OFFSET_X + 32, 219, VIRTUAL_WIDTH, 'center')

        -- text
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('+ ' .. tostring(math.abs(material_difference)), BOARD_OFFSET_X + 32, 220, VIRTUAL_WIDTH, 'center')
    end
end

--[[
    return opposite turn's color
]]
function PlayState:getOppTurn()
    if self.turn == 'white' then
        return 'black'
    else
        return 'white'
    end
end

--[[
    returns the opposite color
]]
function PlayState:getOppColor(color)
    if color == 'white' then
        return 'black'
    elseif color == 'black' then
        return 'white'
    end
end