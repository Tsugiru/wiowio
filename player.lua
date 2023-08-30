local entity = require("entity")
local animation = require("animation")
local input = require("input")

local player = entity.new()

player.width = 32
player.height = 32

player.animation = animation(
  love.graphics.newImage("resources/characters.png"),
  player.width,
  player.height,
  --[[row]] 0,
  --[[start_column]] 0,
  --[[end_column]] 4,
  --[[duration]] 1)

player.direction = {
  x = 0,
  y = 0
}

input:addObserver(player)

local key_pressed_map = {
  w = function()
    player.direction.y = player.direction.y - 1
  end,
  a = function()
    player.direction.x = player.direction.x - 1
  end,
  s = function()
    player.direction.y = player.direction.y + 1
  end,
  d = function()
    player.direction.x = player.direction.x + 1
  end,
}

local key_released_map = {
  w = function()
    player.direction.y = player.direction.y + 1
  end,
  a = function()
    player.direction.x = player.direction.x + 1
  end,
  s = function()
    player.direction.y = player.direction.y - 1
  end,
  d = function()
    player.direction.x = player.direction.x - 1
  end,
}

function player:draw()
  self.animation:draw(
    self.x - self.width / 2,
    self.y - self.height / 2)
end

function player:update(dt)
  self.animation:animate(dt)
end

function player:onKeyPressed(key)
  if key_pressed_map[key] then
    key_pressed_map[key]()
  end
end

function player:onKeyReleased(key)
  if key_released_map[key] then
    key_released_map[key]()
  end
end

return player
