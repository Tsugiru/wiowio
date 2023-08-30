local player = require("player")
local enemy = require("enemy")

function normalize_vector(v)
  local magnitude = math.sqrt(v.x * v.x + v.y * v.y)
  v.x = (magnitude ~= 0) and v.x / magnitude or 0
  v.y = (magnitude ~= 0) and v.y / magnitude or 0
end

function scale_vector(v, a)
  v.x = a * v.x
  v.y = a * v.y
end

local physics = {
  meter = 32
}

function physics:update(dt)
  -- update player
  local player_velocity = 64.
  if player.direction.x ~= 0 and player.direction.y ~= 0 then
    player_velocity = player_velocity / math.sqrt(2)
  end
  player.x = player.x + player.direction.x * player_velocity * dt
  player.y = player.y + player.direction.y * player_velocity * dt

  -- update enemy
  local enemy_velocity = 32.
  local enemy_direction = {
    x = player.x - enemy.x,
    y = player.y - enemy.y
  }
  normalize_vector(enemy_direction)
  scale_vector(enemy_direction, enemy_velocity)
  enemy.x = enemy.x + enemy_direction.x * dt
  enemy.y = enemy.y + enemy_direction.y * dt
end

return physics
