local entity = require("entity")
local animation = require("animation")

local enemy = entity.new()

function enemy.new(x_, y_, id_)
  local self = {x = x_, y = y_, width = 32, height = 32, id = id_}
  self.animation = animation(
    love.graphics.newImage("resources/characters.png"),
    self.width,
    self.height,
    --[[row]] 1,
    --[[start_column]] 0,
    --[[end_column]] 4,
    --[[duration]] 1)
  setmetatable(self, {__index = enemy})
  return self
end

function enemy:draw()
  self.animation:draw(
    self.x - self.width / 2,
    self.y - self.height / 2)
end

function enemy:update(dt)
  self.animation:animate(dt)
end

return enemy
