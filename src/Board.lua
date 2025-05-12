--[[
    The Board is our piece handler using a table of pieces
]]

Board = Class{}

function Board:init()
    -- table of all pieces on the board
    self.pieces = {}

    -- generate pieces for new game

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

    -- en passant
    -- still needs promotions
    elseif piece.pieceType == 'pawn' then
        return self:pawnMoves(piece)

    elseif piece.pieceType == 'bishop' then
        return self:bishopMoves(piece)

    elseif piece.pieceType == 'rook' then
        return self:rookMoves(piece)
        
    elseif piece.pieceType == 'queen' then
        return TableConcat(self:bishopMoves(piece), self:rookMoves(piece))

    -- still needs castling
    elseif piece.pieceType == 'king' then
        return self:kingMoves(piece)
    end
end

--[[
    knight legal moves code
]]
function Board:knightMoves(piece)
    local legalMoves = {}
    local possibleMoves = {}
    possibleMoves = { 
        -- 8 possible moves for knight
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 2},
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 2},
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 2},
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 2},
        { ['gridX'] = piece.gridX + 2, ['gridY'] = piece.gridY + 1},
        { ['gridX'] = piece.gridX - 2, ['gridY'] = piece.gridY + 1},
        { ['gridX'] = piece.gridX + 2, ['gridY'] = piece.gridY - 1},
        { ['gridX'] = piece.gridX - 2, ['gridY'] = piece.gridY - 1}
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
    pawn legal moves code
]]
function Board:pawnMoves(piece)
    local possibleMoves = {}
    local legalMoves = {}
    -- player 1 can only move -y
    if piece.player == 1 then
        -- 4 possible moves for bottom pawns
        possibleMoves = {
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 2, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false}
        }
    -- player 2 can only move +y
    else
        -- 4 possible moves for top pawns
        possibleMoves = {
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 2, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false},
            { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 1, ['triggersEnPassant'] = false, ['enPassantTake'] = false}
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
    bishop legal moves code
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
    rook legal moves code
]]
function Board:rookMoves(piece)
    local legalMoves = {}
    -- check right side moves
    local checkX = piece.gridX + 1
    local checkY = piece.gridY

    while checkX <= 8 do
        -- check if there are pieces on this square
        if self:emptySquare(checkX, checkY) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
        -- check if its an opposite color piece
        -- we are done looking, add this piece to the legal moves and breakout of the loop
        elseif self:oppColor(checkX, checkY, piece) then
            table.insert(legalMoves, { ['gridX'] = checkX, ['gridY'] = checkY })
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
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY - 1},
        { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY - 1},
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY - 1},

        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY},
        { ['gridX'] = piece.gridX + 1, ['gridY'] = piece.gridY + 1},

        { ['gridX'] = piece.gridX, ['gridY'] = piece.gridY + 1},
        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY + 1},

        { ['gridX'] = piece.gridX - 1, ['gridY'] = piece.gridY}
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