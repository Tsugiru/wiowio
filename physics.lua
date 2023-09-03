local player = require("player")
local coordinator = require("enemy_coordinator")

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
  meter = 32,
  enemy_velocity = 32.,
  player_velocity = 64.,
}

function physics:update_enemy(dt)
  for _, enemy in ipairs(coordinator.enemies) do
    local enemy_velocity_vector = {
      x = player.x - enemy.x,
      y = player.y - enemy.y,
    }
    normalize_vector(enemy_velocity_vector)
    scale_vector(enemy_velocity_vector, self.enemy_velocity)
    enemy.x = enemy.x + enemy_velocity_vector.x * dt
    enemy.y = enemy.y + enemy_velocity_vector.y * dt
  end
end

function physics:update(dt)
  -- update player
  local player_velocity_vector = {
    x = player.direction.x,
    y = player.direction.y,
  }
  normalize_vector(player_velocity_vector)
  scale_vector(player_velocity_vector, self.player_velocity)
  player.x = player.x + player_velocity_vector.x * dt
  player.y = player.y + player_velocity_vector.y * dt

  self:update_enemy(dt)
end

return physics
