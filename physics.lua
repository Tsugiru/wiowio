local player = require("player")
local enemy_coordinator = require("enemy_coordinator")
local bullet_coordinator = require("bullet_coordinator")
local geometry = require("geometry_utils")

local physics = {
  meter = 32,
  enemy_velocity = 100.,
  player_velocity = 64.,
  bullet_velocity = 160.,
}

function physics:update_enemies(dt)
  for _, enemy in ipairs(enemy_coordinator.enemies) do
    local enemy_velocity_vector =
    geometry.modify_magnitude({
      x = player.x - enemy.x,
      y = player.y - enemy.y,
    }, self.enemy_velocity)

    enemy.x = enemy.x + enemy_velocity_vector.x * dt
    enemy.y = enemy.y + enemy_velocity_vector.y * dt
  end
end

function physics:update_player(dt)
  -- update player
  local player_velocity_vector = geometry.modify_magnitude({
    x = player.direction.x,
    y = player.direction.y,
  }, self.player_velocity)

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

function physics:resolve_collision(entity1, entity2)
  local intersection = geometry.rectangle_intersection(entity1, entity2)

  if not intersection then
    return
  end

  if intersection.width < intersection.height then
    local dir = entity1.x > entity2.x and 1 or -1
    entity1.x = entity1.x + dir * math.ceil(intersection.width / 2)
    entity2.x = entity2.x - dir * math.ceil(intersection.width / 2)
  else
    local dir = entity1.y > entity2.y and 1 or -1
    entity1.y = entity1.y + dir * math.ceil(intersection.height / 2)
    entity2.y = entity2.y - dir * math.ceil(intersection.height / 2)
  end
end

function physics:resolve_collisions()
  for i = 1, #enemy_coordinator.enemies - 1 do
    for j = i + 1, #enemy_coordinator.enemies do
      self:resolve_collision(
        enemy_coordinator.enemies[i],
        enemy_coordinator.enemies[j])
    end
  end
end

function physics:update(dt)
  self:update_player(dt)
  self:update_enemies(dt)
  self:update_bullets(dt)

  -- Here, call order matters. It's important to call `resolve_collisions` after having updated
  -- the positions of all of the entities, since we rely on `entity.last_x` and `entity.last_y`,
  -- which start off as initially nil for new entities.
  self:resolve_collisions()
end

return physics
