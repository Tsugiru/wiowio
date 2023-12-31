local enemy = require("enemy")
local player = require("player")

local coordinator = {}

coordinator.time_since_last_spawn = 0
coordinator.spawn_interval = 0.5
coordinator.enemies = {}
coordinator.next_id = 0

function coordinator:update(dt)
  -- TODO: make it work for dt greater than `spawn_interval`
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
     --[[y=]]player.y + math.sin(angle) * 200,
     --[[id=]]self.next_id))
  self.next_id = self.next_id + 1
end

function coordinator:remove_enemy(id)
  self.enemies[id] = nil
end

return coordinator
