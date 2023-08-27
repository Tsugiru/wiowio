local entity = require("entity")

local enemy = entity.new()

function enemy.new()
  local self = {}
  setmetatable(self, {__index = enemy})
  return self
end
