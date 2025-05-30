--[[
    State for selecting Player 1's color
    Just render some buttons and jump into the selected play state with the selected color
]]
ColorSelectState = Class{__includes = MenuState}

function ColorSelectState:enter(params)
    self.buttons = {}
    -- playstate type, 1 player or 2 player game
    self.ps_type = params.ps_type

    if math.random(1, 2) == 1 then
        self.randomColor = 'white'
    else
        self.randomColor = 'black'
    end

    table.insert(self.buttons, Button('White', 'menu', function() gStateMachine:change(self.ps_type, { p1_color = 'white' }) end))
    table.insert(self.buttons, Button('Black', 'menu', function() gStateMachine:change(self.ps_type, { p1_color = 'black' }) end))
    table.insert(self.buttons, Button('Random', 'menu', function() gStateMachine:change(self.ps_type, { p1_color = self.randomColor }) end))

    self.margin = 16
    self.total_button_height = (MENU_BUTTON_HEIGHT + self.margin)  * #self.buttons
end

function ColorSelectState:update(dt)
    -- delays buttons by 5 frames to prevent input bleeding
    for i, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function ColorSelectState:render()
    -- cursor for drawing menu buttons
    local cursor_y = 0

    for i, button in ipairs(self.buttons) do
        -- center buttons horizontally
        -- center vertically - offset down by one button
        local bx = (VIRTUAL_WIDTH * 0.5) - (button.width * 0.5)
        local by = (VIRTUAL_HEIGHT * 0.5) - (self.total_button_height * 0.5) + cursor_y + button.height

        button:render(bx, by)

        cursor_y = cursor_y + button.height + self.margin
    end

    -- draw title
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Choose Player 1 Color', 0, 45, VIRTUAL_WIDTH, 'center')

    --[[ -- draw decorative pieces
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_KING], 225, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_QUEEN], 205, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_KING], 379, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_QUEEN], 401, 47) ]]
end