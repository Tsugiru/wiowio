local entity = require("entity")
local input = require("input")

local bullet = entity.new()

bullet.radius = 5

function bullet.new(x_, y_, direction_)
  local self = {x = x_, y = y_, direction = direction_}
  setmetatable(self, {__index = bullet})
  return self
end

function bullet:draw()
  love.graphics.circle("fill", self.x, self.y, self.radius)
end

return bullet
