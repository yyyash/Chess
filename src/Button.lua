--[[
    Button for GUI elements
]]

Button = Class{}

function Button:init(text, bt, fn)
    self.text = text
    -- button type
    self.bt = bt
    -- button function
    self.fn = fn
    
    if self.bt == 'menu' then
        self.width = MENU_BUTTON_WIDTH
        self.height = MENU_BUTTON_HEIGHT
        self.delay = 5

    elseif self.bt == 'play' then
        self.width = PLAY_BUTTON_WIDTH
        self.height = PLAY_BUTTON_HEIGHT
        self.delay = 0
    end

    -- so we execute button function only one time when button is clicked
    self.now = false
    self.last = false
end

--[[
    prevents input bleeding by delaying functionality of buttons
    decrements delay value each time update is called
]]
function Button:update(dt)

    if self.delay > 0 then
        self.delay = self.delay - 1
    end

end

function Button:render(x, y)
    self.last = self.now

    local bx = x
    local by = y
    local hot = false
    local color = {1, 1, 1, 1}
    local icon_color = {1, 1, 1, 1}

    if self.bt == 'play' then
        color = {70/255, 73/255, 75/255, 1}
    end

    local mx, my = push:toGame(love.mouse.getPosition())

    -- button is hot if the mouse is hovering over it
    if mx ~= nil and my ~= nil and self.delay == 0 then
        hot = mx > bx and mx < bx + self.width and
                my > by and my < by + self.height
    end

    if hot then
        -- change the color so we know button is live
        color = {240/255, 38/255, 38/255, .9}
        icon_color = {1, 1, 1, 1}
    end

    -- if button was pressed this time, but not the last time we checked
    -- call the button function
    self.now = love.mouse.isDown(1)
    if self.now and not self.last and hot then
        self.fn()
    end

    if self.bt == 'play' then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', bx - 1, by - 1, self.width + 2, self.height + 2)
    end

    -- draw the box background
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle(
        'fill',
        bx,
        by,
        self.width,
        self.height 
    )

    if self.bt == 'menu' then
        local textW = gFonts['small']:getWidth(self.text)
        local textH = gFonts['small']:getHeight(self.text)

        love.graphics.setColor(0, 0 , 0, 1)
        love.graphics.print(
            self.text,
            gFonts['small'],
            (VIRTUAL_WIDTH * 0.5) - (textW * 0.5),
            by + self.height * 0.5 - (textH * 0.5)
        )

    elseif self.bt == 'play' and self.text == 'restart' then
        love.graphics.setColor(unpack(icon_color))
        love.graphics.draw(gTextures['ui_buttons'], gFrames['ui_buttons'][RESTART_BUTTON], bx + 1, by + 1)

    elseif self.bt == 'play' and self.text == 'home' then
        love.graphics.setColor(unpack(icon_color))
        love.graphics.draw(gTextures['ui_buttons'], gFrames['ui_buttons'][HOME_BUTTON], bx, by + 1)
    end
end

