--[[
    The Board is our piece handler using a table of pieces
]]

Board = Class{}

function Board:init(p1_color, is_cloning)
    -- table of all pieces on the board
    self.pieces = {}
    self.p1_color = p1_color

    if self.p1_color == 'white' then
        self.p2_color = 'black'
    else
        self.p2_color = 'white'
    end

    self.turn = 'white'

    self.checkmate = ''
    self.stalemate = false

    if not is_cloning then
        -- generate pieces for new game
        -- player 1 is white
        if p1_color == 'white' then

            -- white pawns
            for i = 1, 8 do
                table.insert(self.pieces, Piece(i, 7, 'white', 'pawn', WHITE_PAWN, 1))     
            end

            -- white rooks
            table.insert(self.pieces, Piece(1, 8, 'white', 'rook', WHITE_ROOK, 1))
            table.insert(self.pieces, Piece(8, 8, 'white', 'rook', WHITE_ROOK, 1))

            -- white knights
            table.insert(self.pieces, Piece(2, 8, 'white', 'knight', WHITE_KNIGHT, 1))
            table.insert(self.pieces, Piece(7, 8, 'white', 'knight', WHITE_KNIGHT, 1))

            -- white bishops
            table.insert(self.pieces, Piece(3, 8, 'white', 'bishop', WHITE_BISHOP, 1))
            table.insert(self.pieces, Piece(6, 8, 'white', 'bishop', WHITE_BISHOP, 1))

            -- white queen
            table.insert(self.pieces, Piece(4, 8, 'white', 'queen', WHITE_QUEEN, 1))

            -- white king
            table.insert(self.pieces, Piece(5, 8, 'white', 'king', WHITE_KING, 1))

            -- black pawns
            for i = 1, 8 do
                table.insert(self.pieces, Piece(i, 2, 'black', 'pawn', BLACK_PAWN, 2))     
            end

            -- black rooks
            table.insert(self.pieces, Piece(1, 1, 'black', 'rook', BLACK_ROOK, 2))
            table.insert(self.pieces, Piece(8, 1, 'black', 'rook', BLACK_ROOK, 2))

            -- black knights
            table.insert(self.pieces, Piece(2, 1, 'black', 'knight', BLACK_KNIGHT, 2))
            table.insert(self.pieces, Piece(7, 1, 'black', 'knight', BLACK_KNIGHT, 2))

            -- black bishops
            table.insert(self.pieces, Piece(3, 1, 'black', 'bishop', BLACK_BISHOP, 2))
            table.insert(self.pieces, Piece(6, 1, 'black', 'bishop', BLACK_BISHOP, 2))

            -- black queen
            table.insert(self.pieces, Piece(4, 1, 'black', 'queen', BLACK_QUEEN, 2))

            -- black king
            table.insert(self.pieces, Piece(5, 1, 'black', 'king', BLACK_KING, 2))

        -- player 1 is black
        elseif p1_color == 'black' then

            -- black pawns
            for i = 1, 8 do
                table.insert(self.pieces, Piece(i, 7, 'black', 'pawn', BLACK_PAWN, 1))     
            end

            -- black rooks
            table.insert(self.pieces, Piece(1, 8, 'black', 'rook', BLACK_ROOK, 1))
            table.insert(self.pieces, Piece(8, 8, 'black', 'rook', BLACK_ROOK, 1))

            -- black knights
            table.insert(self.pieces, Piece(2, 8, 'black', 'knight', BLACK_KNIGHT, 1))
            table.insert(self.pieces, Piece(7, 8, 'black', 'knight', BLACK_KNIGHT, 1))

            -- black bishops
            table.insert(self.pieces, Piece(3, 8, 'black', 'bishop', BLACK_BISHOP, 1))
            table.insert(self.pieces, Piece(6, 8, 'black', 'bishop', BLACK_BISHOP, 1))

            -- black queen
            table.insert(self.pieces, Piece(5, 8, 'black', 'queen', BLACK_QUEEN, 1))

            -- black king
            table.insert(self.pieces, Piece(4, 8, 'black', 'king', BLACK_KING, 1))

            -- white pawns
            for i = 1, 8 do
                table.insert(self.pieces, Piece(i, 2, 'white', 'pawn', WHITE_PAWN, 2))     
            end

            -- white rooks
            table.insert(self.pieces, Piece(1, 1, 'white', 'rook', WHITE_ROOK, 2))
            table.insert(self.pieces, Piece(8, 1, 'white', 'rook', WHITE_ROOK, 2))

            -- white knights
            table.insert(self.pieces, Piece(2, 1, 'white', 'knight', WHITE_KNIGHT, 2))
            table.insert(self.pieces, Piece(7, 1, 'white', 'knight', WHITE_KNIGHT, 2))

            -- white bishops
            table.insert(self.pieces, Piece(3, 1, 'white', 'bishop', WHITE_BISHOP, 2))
            table.insert(self.pieces, Piece(6, 1, 'white', 'bishop', WHITE_BISHOP, 2))

            -- white queen
            table.insert(self.pieces, Piece(5, 1, 'white', 'queen', WHITE_QUEEN, 2))

            -- white king
            table.insert(self.pieces, Piece(4, 1, 'white', 'king', WHITE_KING, 2))
        end 
    end
end

function Board:clone()
    -- create new board using boards constructor
    local clonedBoard = Board(self.p1_color, true)

    -- copy attributes
    clonedBoard.turn = self.turn
    clonedBoard.checkmate = self.checkmate
    clonedBoard.stalemate = self.stalemate

    -- copy table of pieces
    clonedBoard.pieces = {}
    for i, piece in ipairs(self.pieces) do
        table.insert(clonedBoard.pieces, piece:clone())
    end

    return clonedBoard
end

function Board:render()
    -- draw the board
    love.graphics.setColor(1, 1, 1, 1)
    for y = 0, 3 do
        for x = 0, 3 do
            love.graphics.draw(gTextures['assets'], gFrames['boardQuad'], 
            64 * x + BOARD_OFFSET_X, 
            64 * y + BOARD_OFFSET_Y)
        end
    end

    -- draw the border
    -- corners
    love.graphics.draw(gTextures['assets'], gFrames['top_left_border'], 176, 36)
    love.graphics.draw(gTextures['assets'], gFrames['top_right_border'], 448, 36)
    love.graphics.draw(gTextures['assets'], gFrames['bottom_left_border'], 176, 308)
    love.graphics.draw(gTextures['assets'], gFrames['bottom_right_border'], 448, 308)
    -- sides
    for x = 0, 3 do
        love.graphics.draw(gTextures['assets'], gFrames['top_border'], 192 + x * 64, 36)
    end
    for x = 0, 3 do
        love.graphics.draw(gTextures['assets'], gFrames['bottom_border'], 192 + x * 64, 308)
    end
    for y = 0, 3 do
        love.graphics.draw(gTextures['assets'], gFrames['left_border'], 176, 52 + y * 64)
    end
    for y = 0, 3 do
        love.graphics.draw(gTextures['assets'], gFrames['right_border'], 448, 52 + y * 64)
    end

    -- draw the pieces
    for i = 1, #self.pieces do
        self.pieces[i]:render()
    end
end

--[[
    gets moves for a selected piece
    this function doesn't consider putting yourself in check
    we have to check for that condition elsewhere
    in order to calculate check we need to access all of the available moves for all of the pieces
]]
function Board:getMoves(piece)
    local legalMoves = {}
    local possibleMoves = {}

    if piece.pieceType == 'knight' then
        return self:knightMoves(piece)

    elseif piece.pieceType == 'pawn' then
        return self:pawnMoves(piece)

    elseif piece.pieceType == 'bishop' then
        return self:bishopMoves(piece)

    elseif piece.pieceType == 'rook' then
        return self:rookMoves(piece)
        
    elseif piece.pieceType == 'queen' then
        return TableConcat(self:bishopMoves(piece), self:rookMoves(piece))

    elseif piece.pieceType == 'king' then
        return self:kingMoves(piece)
    end
end

--[[
    get all moves for a certain color
]]
function Board:getAllMoves(color)
    local allMoves = {}
    for i = 1, #self.pieces do
        if self.pieces[i].color == color then
            TableConcat(allMoves, self:getMoves(self.pieces[i]))
            --table.insert(allMoves, self:getMoves(self.pieces[i]))
        end
    end
    return allMoves
end

--[[
    look for check
    returns true if player is in check
]]
function Board:getCheck(color, moves)
    -- for all moves in the moves table
    -- check if the king has the same gridX and gridY as a move from the move table
    local kingX, kingY = self:getKingPos(color)

    --[[ --debug
    print(color .. ' king pos = ' .. kingX .. ', ' .. kingY) ]]

    if moves ~= nil then
        for i = 1, #moves do
            if moves[i]['gridX'] == kingX and moves[i]['gridY'] == kingY then
                return true
            end
        end
    end
    return false
end

--[[
    simple check
    loop through all pieces and return true if a king is in check
]]
function Board:inCheck(color)
    for i = 1, #self.pieces do
        if self.pieces[i].pieceType == 'king' and self.pieces[i].color == color and self.pieces[i].inCheck  then
            return true
        end
    end
    -- if we got here, there is no check on the board
    return false
end

--[[
    sets inCheck value for the king
]]
function Board:setCheck(color)
    for i = 1, #self.pieces do
        if self.pieces[i].color == color and self.pieces[i].pieceType == 'king' then
            if self.pieces[i].inCheck == false then
                self.pieces[i].inCheck = true
            end
            return
        end
    end
end

--[[
    resets inCheck value for the king
]]
function Board:resetCheck(color)
    for i = 1, #self.pieces do
        if self.pieces[i].color == color and self.pieces[i].pieceType == 'king' then
            if self.pieces[i].inCheck == true then
                self.pieces[i].inCheck = false
            end
            return
        end
    end
end

--[[
    knight moves
]]
function Board:knightMoves(piece)
    local legalMoves = {}
    local possibleMoves = {}
    possibleMoves = { 
        -- 8 possible moves for knight
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 2, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 2, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 2, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 2, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX + 2, ['gridY'] = piece.gridY + 1, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX - 2, ['gridY'] = piece.gridY + 1, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX + 2, ['gridY'] = piece.gridY - 1, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
        { ['gridX'] = piece.gridX - 2, ['gridY'] = piece.gridY - 1, ['startX'] = piece.gridX, ['startY'] = piece.gridY}
    }
    -- only include moves that are inbounds and land on an opposite color piece or an empty square
    for i = 1, #possibleMoves do
        if self:gridInBounds(possibleMoves[i]['gridX'], possibleMoves[i]['gridY']) and 
            (self:oppColor(possibleMoves[i]['gridX'], possibleMoves[i]['gridY'], piece) or self:emptySquare(possibleMoves[i]['gridX'], possibleMoves[i]['gridY'])) then
                table.insert(legalMoves, possibleMoves[i])
        end
    end
    return legalMoves
end

--[[
    pawn moves
]]
function Board:pawnMoves(piece)
    local possibleMoves = {}
    local legalMoves = {}
    -- player 1 can only move -y
    if piece.player == 1 then
        -- 4 possible moves for bottom pawns
        possibleMoves = {
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 2, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY}
        }
    -- player 2 can only move +y
    else
        -- 4 possible moves for top pawns
        possibleMoves = {
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 2, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY},
            { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY}
        }
    end
    -- check if first forward move has an empty space and it is in bounds
    if self:emptySquare(possibleMoves[1]['gridX'], possibleMoves[1]['gridY']) and self:gridInBounds(possibleMoves[1]['gridX'], possibleMoves[1]['gridY']) then
        table.insert(legalMoves, possibleMoves[1])
        -- check if the second forward move has an empty space, is in bounds, and its the first move
        if self:emptySquare(possibleMoves[2]['gridX'], possibleMoves[2]['gridY']) and self:gridInBounds(possibleMoves[2]['gridX'], possibleMoves[2]['gridY']) and piece.firstMove then
            table.insert(legalMoves, possibleMoves[2])
            -- check if this move would set the en passant flag
            -- if the first move was used to skip over a square attacked by an opponent's pawn, this triggers en passant
            -- so if we first move to a spot that has an enemy pawn to the left or right, we trigger en passant
            
            -- check left
            if self:oppColor(possibleMoves[2]['gridX'] - 1, possibleMoves[2]['gridY'], piece) and self:pieceType(possibleMoves[2]['gridX'] - 1, possibleMoves[2]['gridY']) == 'pawn' then
            -- set flag so that playstate can check and set en passant if this move is chosen
                legalMoves[2]['triggersEnPassant'] = true
            -- check right
            elseif self:oppColor(possibleMoves[2]['gridX'] + 1, possibleMoves[2]['gridY'], piece) and self:pieceType(possibleMoves[2]['gridX'] + 1, possibleMoves[2]['gridY']) == 'pawn' then
                legalMoves[2]['triggersEnPassant'] = true
            end
        end
    end
    -- check conditions for diagonal moves
    -- needs to be an opposite color piece on the diagonals
    -- en passant conditions go in here too eventually
    for i = 3, 4 do
        -- if the diagonal squares have an opposite color piece, its a legal move
        if self:oppColor(possibleMoves[i]['gridX'], possibleMoves[i]['gridY'], piece) then
            table.insert(legalMoves, possibleMoves[i])
        -- if the diagonal squares are empty, check for en passant
        elseif self:emptySquare(possibleMoves[i]['gridX'], possibleMoves[i]['gridY']) then
            -- check to the left for en passant flagged pawn
            -- i = 4 is the left diagonal move
            -- only add this to the legal moves table for the left diagonal move
            if self:checkEnPassant(piece.gridX - 1, piece.gridY) and i == 4 then
                --add a flag to the legal move so that playstate can check to take the piece
                possibleMoves[i]['enPassantTake'] = true
                table.insert(legalMoves, possibleMoves[i])
            -- check to the right for en passant flagged pawn
            -- i = 3 is the right diagonal move
            -- only add this to the legal moves table for the right diagonal move
            elseif self:checkEnPassant(piece.gridX + 1, piece.gridY) and i == 3 then
                --add a flag to the legal move so that playstate can check to take the piece
                possibleMoves[i]['enPassantTake'] = true
                table.insert(legalMoves, possibleMoves[i])
            end
        end
    end
    return legalMoves
end

--[[
    bishop moves
]]
function Board:bishopMoves(piece)
    local legalMoves = {}
    -- variables for checking diagonal pieces
    -- initialize to check for bottom right moves
    local checkX = piece.gridX + 1
    local checkY = piece.gridY + 1
    -- while gridX and gridY are in bounds
    -- check moves until we are out of bounds
    while checkX <= 8 and checkY <= 8 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX + 1
        checkY = checkY + 1
    end  
    -- reset check variables for top right moves
    checkX = piece.gridX + 1
    checkY = piece.gridY - 1
    -- check top right diagonal moves
    while checkX <= 8 and checkY >= 1 do
    -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX + 1
        checkY = checkY - 1
    end  
    -- reset check variables for bottom left moves
    checkX = piece.gridX - 1
    checkY = piece.gridY + 1
    -- check bottom left moves
    while checkX >= 1 and checkY <= 8 do
    -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX - 1
        checkY = checkY + 1
    end
    -- reset check variables for bottom left moves
    checkX = piece.gridX - 1
    checkY = piece.gridY - 1
    -- check top left moves
    while checkX >= 1 and checkY >= 1 do
    -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX - 1
        checkY = checkY - 1
    end
    return legalMoves
end

--[[
    rook moves
]]
function Board:rookMoves(piece)
    local legalMoves = {}
    -- check right side moves
    local checkX = piece.gridX + 1
    local checkY = piece.gridY

    while checkX <= 8 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX + 1
    end  

    -- reset checkX, check left side moves
    local checkX = piece.gridX - 1

    while checkX >= 1 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkX = checkX - 1
    end  

    -- reset checkX for checking top moves
    local checkX = piece.gridX
    local checkY = piece.gridY - 1

    while checkY >= 1 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkY = checkY - 1
    end

    -- reset checkX for checking bottom moves
    local checkY = piece.gridY + 1

    while checkY <= 8 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
            break
        -- same color piece is here, don't add to legal moves table, just breakout
        else
            break
        end
        checkY = checkY + 1
    end
    return legalMoves
end

--[[
    king moves
]]
function Board:kingMoves(piece)
    local legalMoves = {}
    local possibleMoves = {
        -- 8 possible moves for king
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },
        { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },

        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },

        { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 1, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY },

        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY, ['castleLeft'] = false, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY }
    }

    -- only include moves that are inbounds and land on an opposite color piece or an empty square
    for i = 1, #possibleMoves do
        if self:gridInBounds(possibleMoves[i]['gridX'], possibleMoves[i]['gridY']) and 
            (self:oppColor(possibleMoves[i]['gridX'], possibleMoves[i]['gridY'], piece) or self:emptySquare(possibleMoves[i]['gridX'], possibleMoves[i]['gridY'])) then
                table.insert(legalMoves, possibleMoves[i])
        end
    end

    -- castling
    -- can only castle if king hasn't moved and is not in check
    if piece.firstMove == true and piece.inCheck == false then
        local emptySquareCount = 0

        -- white is on bottom (short castle right, long castle left)
        if self.p1_color == 'white' then

            -- check to the right (3 squares only)
            -- if there are 2 empty squares followed by a rook that hasn't moved, then castling is legal
            for i = 1, 3 do
                -- if its an empty square, increment the count
                if self:emptySquare(piece.gridX + i, piece.gridY) then
                    emptySquareCount = emptySquareCount + 1
                -- if we already found 2 empty squares
                elseif emptySquareCount == 2 and 
                    -- and its a rook
                    self:pieceType(piece.gridX + i, piece.gridY) == 'rook' and 
                    -- and its the same color
                    piece.color == self:pieceColor(piece.gridX + i, piece.gridY) and
                    -- and that rook hasn't moved
                    self:pieceFirstMove(piece.gridX + i, piece.gridY) then
                        -- king can castle, add right side castle to the legalmoves table
                        table.insert(legalMoves, { ['gridX'] = piece.gridX + i - 1, ['gridY'] = piece.gridY, ['castleLeft'] = false, ['castleRight'] = true, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
                end
            end

            -- check to the left (4 squares only)
            -- if there are 3 empty squares followed by a rook that hasn't moved, then castling is legal
            emptySquareCount = 0
            for i = 1, 4 do
                -- if its an empty square, increment the count
                if self:emptySquare(piece.gridX - i, piece.gridY) then
                    emptySquareCount = emptySquareCount + 1
                -- if we already found 2 empty squares
                elseif emptySquareCount == 3 and 
                    -- and its a rook
                    self:pieceType(piece.gridX - i, piece.gridY) == 'rook' and 
                    -- and its the same color
                    piece.color == self:pieceColor(piece.gridX - i, piece.gridY) and
                    -- and that rook hasn't moved
                    self:pieceFirstMove(piece.gridX - i, piece.gridY) then
                        -- king can castle, add left side castle to the legalmoves table
                        table.insert(legalMoves, { ['gridX'] = piece.gridX - i + 2, ['gridY'] = piece.gridY, ['castleLeft'] = true, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
                end
            end

         -- black is on bottom (short castle left, long castle right)    
        else
            -- check to the right (4 squares only)
            -- if there are 3 empty squares followed by a rook that hasn't moved, then castling is legal
            for i = 1, 4 do
                -- if its an empty square, increment the count
                if self:emptySquare(piece.gridX + i, piece.gridY) then
                    emptySquareCount = emptySquareCount + 1
                -- if we already found 3 empty squares
                elseif emptySquareCount == 3 and 
                    -- and its a rook
                    self:pieceType(piece.gridX + i, piece.gridY) == 'rook' and 
                    -- and its the same color
                    piece.color == self:pieceColor(piece.gridX + i, piece.gridY) and
                    -- and that rook hasn't moved
                    self:pieceFirstMove(piece.gridX + i, piece.gridY) then
                        -- king can castle, add right side castle to the legalmoves table
                        table.insert(legalMoves, { ['gridX'] = piece.gridX + i - 2, ['gridY'] = piece.gridY, ['castleLeft'] = false, ['castleRight'] = true, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
                end
            end

            -- check to the left (3 squares only)
            -- if there are 2 empty squares followed by a rook that hasn't moved, then castling is legal
            emptySquareCount = 0
            for i = 1, 3 do
                -- if its an empty square, increment the count
                if self:emptySquare(piece.gridX - i, piece.gridY) then
                    emptySquareCount = emptySquareCount + 1
                -- if we already found 2 empty squares
                elseif emptySquareCount == 2 and 
                    -- and its a rook
                    self:pieceType(piece.gridX - i, piece.gridY) == 'rook' and 
                    -- and its the same color
                    piece.color == self:pieceColor(piece.gridX - i, piece.gridY) and
                    -- and that rook hasn't moved
                    self:pieceFirstMove(piece.gridX - i, piece.gridY) then
                        -- king can castle, add left side castle to the legalmoves table
                        table.insert(legalMoves, { ['gridX'] = piece.gridX - i + 1, ['gridY'] = piece.gridY, ['castleLeft'] = true, ['castleRight'] = false, ['startX'] = piece.gridX, ['startY'] = piece.gridY })
                end
            end
        end
    end

    return legalMoves 
end

--[[
    moves a piece on a board
    returns table of pieces that were taken
]]
function Board:makeMove(move)
    local taken_pieces = {}
    local piece_to_move = self:getPieceAt(move['startX'], move['startY'])

    -- if there is a piece on this square and its a different color, take it
    if self:emptySquare(move['gridX'], move['gridY']) == false and self:pieceColor(move['gridX'], move['gridY']) ~= piece_to_move.color then
        table.insert(taken_pieces, { 
            ['piece_color'] = self:pieceColor(move['gridX'], move['gridY']), 
            ['piece_type'] = self:pieceType(move['gridX'], move['gridY'])
        })
        self:takePiece(move['gridX'], move['gridY'])
    end
    -- set piece values for the special cases of moves: en passant, castling, pawn promotion
    -- uses flags set in the moves table during move generation

    -- set the enPassantFlag if pawn first moved to an adjecent enemy pawn
    if move['triggersEnPassant'] then
        self:setEnPassant(piece_to_move)

    -- take the pawn by en passant
    elseif move['enPassantTake'] then
        -- check if en passant piece is above
        if self:checkEnPassant(move['gridX'], move['gridY'] + 1) then
            table.insert(taken_pieces, { 
                ['piece_color'] = self:pieceColor(move['gridX'], move['gridY'] + 1), 
                ['piece_type'] = self:pieceType(move['gridX'], move['gridY'] + 1)
            })
            self:takePiece(move['gridX'], move['gridY'] + 1)
        -- check if en passant piece is below
        elseif self:checkEnPassant(move['gridX'], move['gridY'] - 1) then
            table.insert(taken_pieces, { 
                ['piece_color'] = self:pieceColor(move['gridX'], move['gridY'] - 1), 
                ['piece_type'] = self:pieceType(move['gridX'], move['gridY'] - 1)
            })
            self:takePiece(move['gridX'], move['gridY'] - 1)
        end
    end
    
    -- white on bottom
    if self.p1_color == 'white' then
        -- castle short
        if move['castleRight'] then
            for i = 1, #self.pieces do
                -- find the rook to the right of the selected king
                if self.pieces[i].gridX == piece_to_move.gridX + 3 and self.pieces[i].gridY == piece_to_move.gridY and self.pieces[i].pieceType == 'rook' then
                    -- move the rook 1 square to the right of the selected king
                    self.pieces[i]:moveTo(piece_to_move.gridX + 1, piece_to_move.gridY)
                end
            end

        -- castle long
        elseif move['castleLeft'] then
            for i = 1, #self.pieces do
                -- find the rook to the left of the selected king
                if self.pieces[i].gridX == piece_to_move.gridX - 4 and self.pieces[i].gridY == piece_to_move.gridY and self.pieces[i].pieceType == 'rook' then
                    -- move the rook 2 squares to the left of the selected king
                    self.pieces[i]:moveTo(piece_to_move.gridX - 1, piece_to_move.gridY)
                end
            end
        end

    -- black on bottom
    else
        -- castle long
        if move['castleRight'] then
            for i = 1, #self.pieces do
                -- find the rook to the right of the selected king
                if self.pieces[i].gridX == piece_to_move.gridX + 4 and self.pieces[i].gridY == piece_to_move.gridY and self.pieces[i].pieceType == 'rook' then
                    -- move the rook 1 square to the right of the selected king
                    self.pieces[i]:moveTo(piece_to_move.gridX + 1, piece_to_move.gridY)
                end
            end

        -- castle short
        elseif move['castleLeft'] then
            for i = 1, #self.pieces do
                -- find the rook to the left of the selected king
                if self.pieces[i].gridX == piece_to_move.gridX - 3 and self.pieces[i].gridY == piece_to_move.gridY and self.pieces[i].pieceType == 'rook' then
                    -- move the rook 2 squares to the left of the selected king
                    self.pieces[i]:moveTo(piece_to_move.gridX - 1, piece_to_move.gridY)
                end
            end
        end
    end

    -- move the piece to the selected square
    piece_to_move:moveTo(move['gridX'], move['gridY'])

    -- if player 1 just moved and player 2 had an enPassant pawn, reset the enPassant flag
    if self:enPassantColor() ~= nil and self:enPassantColor() ~= piece_to_move.color then
        self:resetEnPassant()
    end

    -- pawn promotion

    -- white on bottom
    if self.p1_color == 'white' then

        if piece_to_move.pieceType == 'pawn' and piece_to_move.gridY == 1 and piece_to_move.color == 'white' then
            piece_to_move.pieceType = 'queen'
            piece_to_move.tileID = WHITE_QUEEN

        elseif piece_to_move.pieceType == 'pawn' and piece_to_move.gridY == 8 and piece_to_move.color == 'black' then
            piece_to_move.pieceType = 'queen'
            piece_to_move.tileID = BLACK_QUEEN
        end

    -- black on bottom
    else

        if piece_to_move.pieceType == 'pawn' and piece_to_move.gridY == 8 and piece_to_move.color == 'white' then
            piece_to_move.pieceType = 'queen'
            piece_to_move.tileID = WHITE_QUEEN

        elseif piece_to_move.pieceType == 'pawn' and piece_to_move.gridY == 1 and piece_to_move.color == 'black' then
            piece_to_move.pieceType = 'queen'
            piece_to_move.tileID = BLACK_QUEEN
        end
    end

    -- sets check if move put opponent in check
    -- resets check if move protected the king
    local all_moves = self:getAllMoves(piece_to_move.color)
    -- look for check on the opposing player and set check on the opposing king
    if self:getCheck(self:getOppColor(piece_to_move), all_moves) then
        self:setCheck(self:getOppColor(piece_to_move))
    end

    -- reset check if we just moved to protect the king
    all_moves = {}
    all_moves = self:getAllMoves(self:getOppColor(piece_to_move))

    if self:getCheck(piece_to_move.color, all_moves) == false then
        self:resetCheck(piece_to_move.color)
    else
        -- we just moved ourself into check, not legal, we should never get here
        self:setCheck(piece_to_move.color)
        -- debug
        print('shit is fucked up yo')
    end

    -- change self.turn
    self.turn = (self.turn == 'white' and 'black') or 'white'

    return taken_pieces
end

--[[
    returns the piece at the grid x, y
]]
function Board:getPieceAt(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            return self.pieces[i]
        end
    end
end

--[[
    takes in a grid x and grid y
    sets the selectedPiece flag
]]
function Board:selectPiece(x, y)
    -- loop through all pieces
    -- return the piece that matches the grid x, grid y
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            self.pieces[i].isSelected = true
            return self.pieces[i]
        end
    end
end

--[[
    takes in a grid x and grid y
    resets the selectedPiece flag
]]
function Board:deselectPiece()
    -- loop through all pieces
    -- return the piece that matches the grid x, grid y
    for i = 1, #self.pieces do
        self.pieces[i].isSelected = false
    end
end

--[[
    returns the piece color of a grid X, grid Y position
]]
function Board:pieceColor(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            return self.pieces[i].color
        end
    end
end

--[[
    returns the piece type at a grid X, grid Y position
]]
function Board:pieceType(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            return self.pieces[i].pieceType
        end
    end
end

--[[
    returns true if the piece hasn't moved
]]
function Board:pieceFirstMove(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            return self.pieces[i].firstMove
        end
    end
end

--[[
    returns true if gridX, gridY is an empty square
]]
function Board:emptySquare(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            return false
        end
    end
    -- if we made it here, there are no pieces on that x, y
    return true
end

--[[
    take piece at gridX, gridY
]]
function Board:takePiece(x, y)
    -- find the index of the piece being taken
    local pieceIndex = nil
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y then
            pieceIndex = i
            break
        end
    end
    -- remove the piece at that index
    if pieceIndex ~= nil then
        table.remove(self.pieces, pieceIndex)
    end
end

--[[
    returns true if grid X, grid Y is in bounds
]]
function Board:gridInBounds(x, y)
    if x > 8 or x < 1 or y > 8 or y < 1 then
        return false
    else
        return true
    end
end

--[[
    returns true if there is an opposite color piece at position X, Y
]]
function Board:oppColor(x, y, piece)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y and self.pieces[i].color ~= piece.color then
            return true
        end
    end
    -- if we made it here, there is either no piece, or a same color piece
    return false
end

--[[
    returns true if there is an en passant flagged pawn at a gridX, gridY position
]]
function Board:checkEnPassant(x, y)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == x and self.pieces[i].gridY == y and self.pieces[i].enPassant then
            return true
        end
    end
    -- if we made it here, there is either no piece, or no enPassant flagged pawns
    return false
end

--[[
    sets enPassant flag to true on the given piece
]]
function Board:setEnPassant(piece)
    for i = 1, #self.pieces do
        if self.pieces[i].gridX == piece.gridX and self.pieces[i].gridY == piece.gridY then
            self.pieces[i].enPassant = true
        end
    end
end

--[[
    resets enPassant flag to false for all pieces
]]
function Board:resetEnPassant()
    for i = 1, #self.pieces do
        self.pieces[i].enPassant = false
    end
end

--[[
    returns color of the pawn with an enPassant flag
]]
function Board:enPassantColor()
    for i = 1, #self.pieces do
        if self.pieces[i].enPassant then
            return self.pieces[i].color
        end
    end
    -- if we made it here there is no pawn with an enPassant flag
    return nil
end

--[[
    gets the kings current position for a player
]]
function Board:getKingPos(color)
    for i = 1, #self.pieces do
        if self.pieces[i].pieceType == 'king' and self.pieces[i].color == color then
            return self.pieces[i].gridX, self.pieces[i].gridY
        end
    end
end

--[[
    returns the opposite color of a piece
]]
function Board:getOppColor(piece)
    if piece.color == 'white' then return 'black'
    else return 'white'
    end
end

--[[
    returns true if the opponent is attacking a gridX, gridY
]]
function Board:oppAttack(x, y, moves)
    for i = 1, #moves do
        if moves[i]['gridX'] == x and moves[i]['gridY'] == y then
            return true
        end
    end
    -- if we got here, the x,y is not being attacked
    return false
end

--[[
    tallys up board material difference
    returns whites piece values - blacks piece values
]]
function Board:materialDifference()

    local total_value = 0

    for i = 1, #self.pieces do

        -- piece value counts
        if self.pieces[i].color == 'white' then
            if self.pieces[i].pieceType == 'pawn' then
                total_value = total_value + 1
            elseif self.pieces[i].pieceType == 'knight' or self.pieces[i].pieceType == 'bishop' then
                total_value = total_value + 3
            elseif self.pieces[i].pieceType == 'rook' then
                total_value = total_value + 5
            elseif self.pieces[i].pieceType == 'queen' then
                total_value = total_value + 9
            end

        else
            if self.pieces[i].pieceType == 'pawn' then
                total_value = total_value - 1
            elseif self.pieces[i].pieceType == 'knight' or self.pieces[i].pieceType == 'bishop' then
                total_value = total_value - 3
            elseif self.pieces[i].pieceType == 'rook' then
                total_value = total_value - 5
            elseif self.pieces[i].pieceType == 'queen' then
                total_value = total_value - 9
            end
        end

    end

    return total_value
end

--[[
    tallys up board material difference
    returns whites piece values - blacks piece values
]]
function Board:eval()

    local eval = 0

    for i = 1, #self.pieces do

        -- piece value counts
        if self.pieces[i].color == self.p2_color then
            if self.pieces[i].pieceType == 'pawn' then
                eval = eval + 1
            elseif self.pieces[i].pieceType == 'knight' or self.pieces[i].pieceType == 'bishop' then
                eval = eval + 3
            elseif self.pieces[i].pieceType == 'rook' then
                eval = eval + 5
            elseif self.pieces[i].pieceType == 'queen' then
                eval = eval + 9
            end

        else
            if self.pieces[i].pieceType == 'pawn' then
                eval = eval - 1
            elseif self.pieces[i].pieceType == 'knight' or self.pieces[i].pieceType == 'bishop' then
                eval = eval - 3
            elseif self.pieces[i].pieceType == 'rook' then
                eval = eval - 5
            elseif self.pieces[i].pieceType == 'queen' then
                eval = eval - 9
            end
        end

    end

    -- checkmate 
    if self.checkmate == self.p2_color then
        eval = math.huge
    elseif self.checkmate == self.p1_color then
        eval = -math.huge
    -- stalemate
    elseif self.stalemate then
        eval = 0
    end

    return eval
end