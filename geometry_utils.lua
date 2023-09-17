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

-- Keeps v in the same direction but modify its magnitude so that it becomes equal to mag.
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
  -- Therefore make sure to account for this by modifying the width and height of the screen.
  return {
    x = player_x - love.graphics.getWidth() / 2 + mouse_x,
    y = player_y - love.graphics.getHeight() / 2 + mouse_y,
  }
end

-- Checks if i1 and i2 are intersecting. Here we assume that if the intervals share a
-- common side, they are not intersecting.
function geometry_utils.interval_intersection(i1, i2)
  local intersection_left = math.max(i1.left, i2.left) 
  local intersection_right = math.min(i1.right, i2.right)
  return intersection_left < intersection_right
    and {left = intersection_left, right = intersection_right}
    or nil
end

-- Returns true if one can find a `c` such that the horizontal line formed by
-- `y = c` intersects both rectangles
function geometry_utils.check_rectangles_horizontally_aligned(r1, r2)
  return geometry_utils.interval_intersection(
      { left = r1.y, right = r1.y + r1.height },
      { left = r2.y, right = r2.y + r2.height })
end

-- Returns true if one can find a `c` such that the vertical line formed by
-- `x = c` intersects both rectangles
function geometry_utils.check_rectangles_vertically_aligned(r1, r2)
  return geometry_utils.interval_intersection(
    { left = r1.x, right = r1.x + r1.width },
    { left = r2.x, right = r2.x + r2.width })
end

-- Returns true if rectangle `rect1` and rectangle `rect2` are intersecting.
-- It's assumed that x and y are the coordinates of the top left corner.
function geometry_utils.rectangle_intersection(r1, r2)
  assert(r1.x and r1.y and r1.width and r1.height,
    "rect1 is not a rectangle")
  assert(r2.x and r2.y and r2.width and r2.height,
    "rect2 is not a rectangle")

  local x_intersect = geometry_utils.interval_intersection(
    { left = r1.x, right = r1.x + r1.width },
    { left = r2.x, right = r2.x + r2.width })
  local y_intersect = geometry_utils.interval_intersection(
        { left = r1.y, right = r1.y + r1.height },
        { left = r2.y, right = r2.y + r2.height })

  if x_intersect and y_intersect then
    return {x = x_intersect.left, y = y_intersect.left,
      width = x_intersect.right - x_intersect.left,
      height = y_intersect.right - y_intersect.left}
  end

  return nil
end

return geometry_utils
