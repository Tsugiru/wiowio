local player = require("player")

local physics = {
  meter = 32
}

function physics:update(dt)
  -- update player
  local velocity = 64.
  if player.direction.x ~= 0 and player.direction.y ~= 0 then
    velocity = velocity / math.sqrt(2)
  end
  player.x = player.x + player.direction.x * velocity * dt
  player.y = player.y + player.direction.y * velocity * dt
end

return physics
