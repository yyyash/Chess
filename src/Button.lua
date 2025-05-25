--[[
    Button for GUI elements
]]

Button = Class{}

function Button:init(text, fn, bt)
    self.text = text
    self.fn = fn
    -- button type
    self.bt = bt

    if self.bt == 'menu' then
        self.width = MENU_BUTTON_WIDTH
        self.height = MENU_BUTTON_HEIGHT
    end

    -- so we execute button function only one time when button is clicked
    self.now = false
    self.last = false
end

function Button:render(x, y)
    self.last = self.now

    local bx = x
    local by = y

    local color = {1, 1, 1, 1}
    local mx, my = push:toGame(love.mouse.getPosition())

    -- button is hot if the mouse is hovering over it
    local hot = mx > bx and mx < bx + self.width and
                my > by and my < by + self.height

    if hot then
        -- change the color so we know button is live
        color = {.4, .4, .4, 1}
    end

    -- if button was pressed this time, but not the last time we checked
    -- call the button function
    self.now = love.mouse.isDown(1)
    if self.now and not self.last and hot then
        self.fn()
    end

    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
        'fill',
        bx,
        by,
        self.width,
        self.height 
    )

    local textW = gFonts['small']:getWidth(self.text)
    local textH = gFonts['small']:getHeight(self.text)

    love.graphics.setColor(0, 0 , 0, 1)
    love.graphics.print(
        self.text,
        gFonts['small'],
        (VIRTUAL_WIDTH * 0.5) - (textW * 0.5),
        by + self.height * 0.5 - (textH * 0.5)
    )
end

