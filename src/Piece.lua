--[[
    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Piece = Class{}

function Piece:init(x, y, color, pieceType, tileID, player)
    -- board positions
    self.gridX = x
    self.gridY = y
    self.isSelected = false

    -- attributes
    self.color = color
    self.pieceType = pieceType
    self.tileID = tileID
    self.player = player
    -- pawns, kings, and rooks
    self.firstMove = true
    -- pawns only
    self.enPassant = false
    -- in check flag
    self.inCheck = false

    -- coordinate positions
    self.x = (self.gridX - 1) * TILE_SIZE + BOARD_OFFSET_X
    self.y = (self.gridY - 1) * TILE_SIZE + BOARD_OFFSET_Y
end

function Piece:render()
    -- make selected piece opaque
    if self.isSelected then
        -- love.graphics.setColor(83/255, 199/255, 31/255, .5)
        love.graphics.setColor(1, 1, 1, .4)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- highlight square red if the king is in check
    if self.inCheck then
        love.graphics.setColor(240/255, 38/255, 38/255, .5)
        love.graphics.rectangle('fill', self.x, self.y, TILE_SIZE, TILE_SIZE)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(gFonts['small'])
        love.graphics.printf(self.color .. ' is in check', 1, 13, VIRTUAL_WIDTH, 'center')
    end

    -- draw piece
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][self.tileID], self.x, self.y)
end

-- changes the pieces gridX, gridY, and coordinate x, y to match
function Piece:moveTo(x, y)
    self.gridX = x
    self.gridY = y
    self.x = (self.gridX - 1) * TILE_SIZE + BOARD_OFFSET_X
    self.y = (self.gridY - 1) * TILE_SIZE + BOARD_OFFSET_Y
    -- turn firstMove flag off
    if self.firstMove == true then
        self.firstMove = false
    end

    -- player 1 pawn promotion
    if self.player == 1 and self.type == 'pawn' and self.gridY == 1 then
        self.pieceType = 'queen'
        self.tileID = WHITE_QUEEN
    elseif self.player == 2 and self.type == 'pawn' and self.gridY == 8 then
        self.pieceType = 'queen'
        self.tildID = BLACK_QUEEN
    end
end
