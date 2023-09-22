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
  for _, enemy in pairs(enemy_coordinator.enemies) do
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
  local player_velocity_vector = geometry.modify_magnitude({
    x = player.direction.x,
    y = player.direction.y,
  }, self.player_velocity)

  player.x = player.x + player_velocity_vector.x * dt
  player.y = player.y + player_velocity_vector.y * dt
end

function physics:update_bullets(dt)
  for _, bullet in pairs(bullet_coordinator.bullets) do
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
  for _, enemy1 in pairs(enemy_coordinator.enemies) do
    for _, enemy2 in pairs(enemy_coordinator.enemies) do
      if enemy1 ~= enemy2 then
        self:resolve_collision(enemy1, enemy2)
      end
    end
  end

  for _, bullet in pairs(bullet_coordinator.bullets) do
    for id, enemy in pairs (enemy_coordinator.enemies) do
      local intersect = geometry.circle_rectangle_intersection(
        { center = { x = bullet.x, y = bullet.y }, radius = bullet.radius },
        enemy)

      if #intersect ~= 0 then
        -- We have intersection.
        enemy_coordinator:remove_enemy(id)
      end
    end
  end
end

function physics:update(dt)
  self:update_player(dt)
  self:update_enemies(dt)
  self:update_bullets(dt)

  self:resolve_collisions()
end

return physics
