--[[
    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Piece = Class{}

function Piece:init(x, y, color, pieceType, tileID)
    -- board positions
    self.gridX = x
    self.gridY = y
    self.isSelected = false

    -- attributes
    self.color = color
    self.pieceType = pieceType
    self.tileID = tileID

    -- coordinate positions
    self.x = (self.gridX - 1) * 32 + BOARD_OFFSET_X
    self.y = (self.gridY - 1) * 32 + BOARD_OFFSET_Y
end

function Piece:render()
    -- make selected piece opaque
    if self.isSelected then
        -- love.graphics.setColor(83/255, 199/255, 31/255, .5)
        love.graphics.setColor(1, 1, 1, .4)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    -- draw piece
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][self.tileID], self.x, self.y)
end
