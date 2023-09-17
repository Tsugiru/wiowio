local enemy = require("enemy")
local player = require("player")

local coordinator = {}

coordinator.time_since_last_spawn = 0
coordinator.spawn_interval = 0.5
coordinator.enemies = {}

function coordinator:update(dt)
  -- TODO: make it work for dt greater than 1.0
  self.time_since_last_spawn = self.time_since_last_spawn + dt
  if self.time_since_last_spawn > self.spawn_interval then
    self.time_since_last_spawn
      = self.time_since_last_spawn - coordinator.spawn_interval
    self:spawn_enemy()
  end
end

function coordinator:spawn_enemy()
  local angle = math.random() * 2 * math.pi
  table.insert(self.enemies, enemy.new(
     --[[x=]]player.x + math.cos(angle) * 200,
     --[[y=]]player.y + math.sin(angle) * 200))
end

return coordinator
