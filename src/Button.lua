--[[
    Button for GUI elements
]]

Button = Class{}

function Button:init(text, fn)
    self.text = text
    self.fn = fn

    self.now = false
    self.last = false
end

function Button:render()

end

