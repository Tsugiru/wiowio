local player = require("player")
local camera = require("camera")
local input = require("input")
local physics = require("physics")
local enemy_coordinator = require("enemy_coordinator")
local bullet_coordinator = require("bullet_coordinator")

function love.draw()
  camera:setPosition(player.x, player.y)
  camera:set()
  love.graphics.rectangle("fill", 0, 0, 32, 32)
  for _, enemy in pairs(enemy_coordinator.enemies) do
    enemy:draw()
  end
  for _, bullet in pairs(bullet_coordinator.bullets) do
    bullet:draw()
  end
  player:draw()
  camera:unset()
end

function love.update(dt)
  player:update(dt)
  enemy_coordinator:update(dt)
  for _, enemy in pairs(enemy_coordinator.enemies) do
    enemy:update(dt)
  end
  physics:update(dt)
end

function love.keypressed(key)
  input:keyPressed(key)
end

function love.keyreleased(key)
  input:keyReleased(key)
end

function love.mousepressed(x, y, button)
  input:mousePressed(x, y, button)
end

function love.load()
end
