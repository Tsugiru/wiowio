local entity = {
  x = 0,
  y = 0,
}

function entity.new()
  local self = {}
  setmetatable(self, {__index = entity})
  return self
end

return entity
