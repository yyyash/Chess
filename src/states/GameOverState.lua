--[[
    game over state
]]
GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.board = params.board
    self.gameOverType = params.gameOverType
    self.buttons = params.buttons
    self.winner = params.winner
    
    self.button_margin = 5
end

function GameOverState:render()
    -- draw board
    self.board:render()

    -- buttons
    for i, button in ipairs(self.buttons) do 
        button:render(( i - 1) * (PLAY_BUTTON_WIDTH + self.button_margin) + 5, 5)
    end

    -- game over message
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
    if self.gameOverType == 'checkmate' then
        love.graphics.printf(self.winner .. ' wins by checkmate', 0, 13, VIRTUAL_WIDTH, 'center')
    elseif self.gameOverType == 'stalemate' then
        love.graphics.printf('draw by stalemate', 0, 13, VIRTUAL_WIDTH, 'center')
    end
end