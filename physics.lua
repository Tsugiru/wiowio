local player = require("player")
local enemy_coordinator = require("enemy_coordinator")
local bullet_coordinator = require("bullet_coordinator")
local geometry = require("geometry_utils")

local physics = {
  meter = 32,
  enemy_velocity = 32.,
  player_velocity = 64.,
  bullet_velocity = 160.,
}

function physics:update_enemies(dt)
  for _, enemy in ipairs(enemy_coordinator.enemies) do
    local enemy_velocity_vector =
    geometry.modify_magnitude({
      x = player.x - enemy.x,
      y = player.y - enemy.y,
    },
      self.enemy_velocity)

    enemy.x = enemy.x + enemy_velocity_vector.x * dt
    enemy.y = enemy.y + enemy_velocity_vector.y * dt
  end
end

function physics:update_player(dt)
  -- update player
  local player_velocity_vector = geometry.modify_magnitude({
    x = player.direction.x,
    y = player.direction.y,
  },
    self.player_velocity)

  player.x = player.x + player_velocity_vector.x * dt
  player.y = player.y + player_velocity_vector.y * dt
end

function physics:update_bullets(dt)
  for _, bullet in ipairs(bullet_coordinator.bullets) do
    local bullet_velocity_vector = geometry.modify_magnitude(
      bullet.direction, self.bullet_velocity)

    bullet.x = bullet.x + bullet_velocity_vector.x * dt
    bullet.y = bullet.y + bullet_velocity_vector.y * dt
  end
end

function physics:update(dt)
  self:update_player(dt)
  self:update_enemies(dt)
  self:update_bullets(dt)
end

return physics
