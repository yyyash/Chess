--[[
    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Piece = Class{}

function Piece:init(x, y, color, pieceType, tileID)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- attributes
    self.color = color
    self.pieceType = pieceType
    self.tileID = tileID

    -- coordinate positions
    self.x = (self.gridX - 1) * 32 + BOARD_OFFSET_X
    self.y = (self.gridY - 1) * 32 + BOARD_OFFSET_Y
end

function Piece:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][self.tileID], self.x, self.y)
end
