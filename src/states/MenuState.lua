--[[
    start state for menu selection
]]
MenuState = Class{__includes = BaseState}

function MenuState:init()
    self.buttons = {}

    table.insert(self.buttons, Button('1 Player Game', function() print("Starting 1 Player Game") end, 'menu'))
    table.insert(self.buttons, Button('2 Player Game', function() gStateMachine:change('play') end,  'menu'))
    table.insert(self.buttons, Button('Exit', function() love.event.quit() end, 'menu'))

    self.margin = 16
    self.total_button_height = (MENU_BUTTON_HEIGHT + self.margin)  * #self.buttons
end

function MenuState:enter()

end

function MenuState:update(dt)

end

function MenuState:render()
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
    love.graphics.printf('Chess', 0, 45, VIRTUAL_WIDTH, 'center')

    -- draw decorative pieces
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_KING], 225, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_QUEEN], 205, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_KING], 379, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_QUEEN], 401, 47)
end