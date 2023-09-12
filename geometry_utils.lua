local geometry_utils = {}

function geometry_utils.normalize_vector(v)
  local magnitude = math.sqrt(v.x * v.x + v.y * v.y)
  return {
    x = (magnitude ~= 0) and v.x / magnitude or 0,
    y = (magnitude ~= 0) and v.y / magnitude or 0,
  }
end

function geometry_utils.scale_vector(v, a)
  return {
    x = a * v.x,
    y = a * v.y,
  }
end

function geometry_utils.add_vector(v1, v2)
  return {
    x = v1.x + v2.x,
    y = v1.y + v2.y
  }
end

-- Scales v so that its magnitude becomes equal to mag.
function geometry_utils.modify_magnitude(v, mag)
    return geometry_utils.scale_vector(
      geometry_utils.normalize_vector(v),
      mag);
end

-- Gets the mouse's "real world" coordinates.
function geometry_utils.get_mouse_world_coordinates(
  mouse_x, mouse_y, player_x, player_y)
  -- TODO: In the future, it might not be correct to assume that the player
  -- stands on the center of the screen (because of camera shifts and such).
  -- Therefore make sure to account for this by modifying the ``
  return {
    x = player_x - love.graphics.getWidth() / 2 + mouse_x,
    y = player_y - love.graphics.getHeight() / 2 + mouse_y,
  }
end

return geometry_utils
