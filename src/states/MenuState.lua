--[[
    start state for menu selection
]]
MenuState = Class{__includes = BaseState}

function MenuState:init()
    self.buttons = {}
    self.button_width = VIRTUAL_WIDTH / 4
    self.button_height = 40
    self.margin = 16

    table.insert(self.buttons, Button('1 Player Game', function() print("Starting 1 Player Game") end))
    table.insert(self.buttons, Button('2 Player Game', function() gStateMachine:change('play') end))
    table.insert(self.buttons, Button('Exit', function() love.event.quit() end))

    self.total_button_height = (self.button_height + self.margin)  * #self.buttons
end

function MenuState:enter()

end

function MenuState:update(dt)

end

function MenuState:render()
    -- draw buttons
    local cursor_y = 0

    for i, button in ipairs(self.buttons) do
        button.last = button.now

        local bx = (VIRTUAL_WIDTH * 0.5) - (self.button_width * 0.5)
        local by = (VIRTUAL_HEIGHT * 0.5) - (self.total_button_height * 0.5) + cursor_y + self.button_height

        local color = {1, 1, 1, 1}
        local mx, my = push:toGame(love.mouse.getPosition())

        local hot = mx > bx and mx < bx + self.button_width and
                    my > by and my < by + self.button_height

        if hot then
            color = {.4, .4, .4, 1}
        end

        button.now = love.mouse.isDown(1)
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            'fill',
            bx,
            by,
            self.button_width,
            self.button_height 
        )

        local textW = gFonts['small']:getWidth(button.text)
        local textH = gFonts['small']:getHeight(button.text)

        love.graphics.setColor(0, 0 , 0, 1)
        love.graphics.print(
            button.text,
            gFonts['small'],
            (VIRTUAL_WIDTH * 0.5) - (textW * 0.5),
            by + self.button_height * 0.5 - (textH * 0.5)
        )

        cursor_y = cursor_y + self.button_height + self.margin
    end

    -- draw Title and decorative pieces
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Chess', 0, 45, VIRTUAL_WIDTH, 'center')

    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_KING], 225, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_WHITE_QUEEN], 205, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_KING], 379, 47)
    love.graphics.draw(gTextures['assets'], gFrames['pieces'][DEC_BLACK_QUEEN], 401, 47)
end