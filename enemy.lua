local entity = require("entity")
local animation = require("animation")

local enemy = entity.new()

enemy.width = 32
enemy.height = 32

enemy.animation = animation(
  love.graphics.newImage("resources/characters.png"),
  enemy.width,
  enemy.height,
  --[[row]] 1,
  --[[start_column]] 0,
  --[[end_column]] 4,
  --[[duration]] 1)

function enemy:draw()
  print(self.x, self.y)
  self.animation:draw(
    self.x - self.width / 2,
    self.y - self.height / 2)
end

function enemy:update(dt)
  self.animation:animate(dt)
end

return enemy
