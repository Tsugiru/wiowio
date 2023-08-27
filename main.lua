local player = require("player")
local camera = require("camera")
local input = require("input")
local physics = require("physics")

function love.draw()
  camera:setPosition(
    player.x,
    player.y)
  camera:set()
  love.graphics.rectangle("fill", 0, 0, 32, 32)
  player:draw()
  camera:unset()
end

function love.update(dt)
  player:update(dt)
  physics:update(dt)
end

function love.keypressed(key)
  input:keyPressed(key)
end

function love.keyreleased(key)
  input:keyReleased(key)
end

function love.load()
end
