local bullet = require("bullet")
local player = require("player")
local geometry = require("geometry_utils")

local coordinator = {}

coordinator.bullets = {}

-- Padding in pixels from where to spawn the bullet that is fired by
-- the player.
coordinator.padding_from_player = 10

function coordinator.new()
  local self = {}
  setmetatable(self, { __index = coordinator })
  return self
end

input:addObserver(coordinator)

function coordinator:onMousePressed(x, y, button)
  if button == 1 then
    -- Left click pressed.
    local mouse_world_coordinates
      = geometry.get_mouse_world_coordinates(x, y, player.x, player.y)
    local direction = geometry.normalize_vector({
      x = mouse_world_coordinates.x - player.x,
      y = mouse_world_coordinates.y - player.y,
    })
    local spawn_point =
      geometry.add_vector({ x = player.x, y = player.y },
        geometry.scale_vector(
          direction,
          self.padding_from_player + (player.width / 2)
        ))

    table.insert(self.bullets, bullet.new(spawn_point.x, spawn_point.y,
      direction))
  end
end

return coordinator
