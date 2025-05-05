--[[
    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init()
    -- table of all pieces on the board
    self.pieces = {}

    -- generate pieces for new game

    -- white pawns
    for i = 1, 8 do
        table.insert(self.pieces, Piece(i, 7, 'white', 'pawn', WHITE_PAWN))     
    end

    -- white rooks
    table.insert(self.pieces, Piece(1, 8, 'white', 'rook', WHITE_ROOK))
    table.insert(self.pieces, Piece(8, 8, 'white', 'rook', WHITE_ROOK))

    -- white knights
    table.insert(self.pieces, Piece(2, 8, 'white', 'knight', WHITE_KNIGHT))
    table.insert(self.pieces, Piece(7, 8, 'white', 'knight', WHITE_KNIGHT))

    -- white bishops
    table.insert(self.pieces, Piece(3, 8, 'white', 'bishop', WHITE_BISHOP))
    table.insert(self.pieces, Piece(6, 8, 'white', 'bishop', WHITE_BISHOP))

    -- white queen
    table.insert(self.pieces, Piece(4, 8, 'white', 'queen', WHITE_QUEEN))

    -- white king
    table.insert(self.pieces, Piece(5, 8, 'white', 'king', WHITE_KING))

    -- black pawns
    for i = 1, 8 do
        table.insert(self.pieces, Piece(i, 2, 'black', 'pawn', BLACK_PAWN))     
    end

    -- black rooks
    table.insert(self.pieces, Piece(1, 1, 'black', 'rook', BLACK_ROOK))
    table.insert(self.pieces, Piece(8, 1, 'black', 'rook', BLACK_ROOK))

    -- black knights
    table.insert(self.pieces, Piece(2, 1, 'black', 'knight', BLACK_KNIGHT))
    table.insert(self.pieces, Piece(7, 1, 'black', 'knight', BLACK_KNIGHT))

    -- black bishops
    table.insert(self.pieces, Piece(3, 1, 'black', 'bishop', BLACK_BISHOP))
    table.insert(self.pieces, Piece(6, 1, 'black', 'bishop', BLACK_BISHOP))

    -- black queen
    table.insert(self.pieces, Piece(4, 1, 'black', 'queen', BLACK_QUEEN))

    -- black king
    table.insert(self.pieces, Piece(5, 1, 'black', 'king', BLACK_KING))
    
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
    start with all 8 possible moves for knight in middle of board
    remove moves that are out of bounds
    check if there is a same color piece for each possible move
    if yes, remove that from the possible moves
    return possible moves table
]]
function Board:knightLegalMoves(piece)
    local possibleMoves = { 
        
        -- 8 possible moves for knight
        -- right and left by 1, up and down by 2
        ['r1d2'] = { piece.gridX + 1, piece.gridY + 2},
        ['l1d2'] = { piece.gridX - 1, piece.gridY + 2},
        ['r1u2'] = { piece.gridX + 1, piece.gridY - 2},
        ['l1u2'] = { piece.gridX - 1, piece.gridY - 2},

        -- right and left by 2, up and down by 1
        ['r2d1'] = { piece.gridX + 2, piece.gridY + 1},
        ['l2d1'] = { piece.gridX - 2, piece.gridY + 1},
        ['r2u1'] = { piece.gridX + 2, piece.gridY - 1},
        ['l2u1'] = { piece.gridX - 2, piece.gridY - 1}
    }

    -- remove moves that are out of bounds
    for k, move in pairs(possibleMoves) do
        if move[1] > 8 or move[1] < 1 or move[2] > 8 or move[2] < 1 then
            table.remove(possibleMoves, move)
        end
    end

    -- remove moves that land on same color piece
    -- for ever move that is left in possible moves
    -- check if any same color pieces are there
    -- if yes, remnove from possible moves table
    for k, move in pairs(possibleMoves) do
        for i = 1, #self.pieces do
            if self.pieces[i].gridX == move[1] and self.pieces[i].gridY == move[2] and 
                self.pieces[i].color == piece.color then
                    table.remove(possibleMoves, move)
                end
            end
        end
    -- if its in bounds and not the same piece, its a legal move
    return possibleMoves
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
