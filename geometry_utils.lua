local utils = require("utils")

local geometry_utils = {}

local function assert_rect(rect, name)
  assert(rect.x and rect.y and rect.height and rect.width, "variable " .. name .. " is not a rectangle")
end

local function assert_circle(circle, name)
  assert(circle.center and circle.center.x and circle.center.y and circle.radius,
    "variable " .. name .. " is not a circle")
end

local eps = 1e-6

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

-- Checks if i1 and i2 are intersecting, and return the interval representing the intersection,
-- or nil otherwise.
-- Here we assume that if the intervals share a common side, they are not intersecting.
function geometry_utils.interval_intersection(i1, i2)
  local intersection_left = math.max(i1.left, i2.left)
  local intersection_right = math.min(i1.right, i2.right)
  return intersection_left < intersection_right
      and { left = intersection_left, right = intersection_right }
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

-- Returns the intersect if rectangle `r1` and rectangle `r2` are intersecting, nil otherwise.
-- It's assumed that x and y are the coordinates of the top left corner.
-- It's assumed that the rectangles are AABBs.
function geometry_utils.rectangle_intersection(r1, r2)
  assert_rect(r1, "r1")
  assert_rect(r2, "r2")

  local x_intersect = geometry_utils.interval_intersection(
    { left = r1.x, right = r1.x + r1.width },
    { left = r2.x, right = r2.x + r2.width })
  local y_intersect = geometry_utils.interval_intersection(
    { left = r1.y, right = r1.y + r1.height },
    { left = r2.y, right = r2.y + r2.height })

  if x_intersect and y_intersect then
    return { x = x_intersect.left, y = y_intersect.left,
      width = x_intersect.right - x_intersect.left,
      height = y_intersect.right - y_intersect.left }
  end

  return nil
end

-- Returns the intersection of circle of radius `r` with line represented by equation ax + by + c = 0.
-- The circle is assumed to be centered at the origin.
-- Return zero, one, or two points.
local function circle_line_intersection_origin(r, a, b, c)
  local x0 = -a * c / (a * a + b * b)
  local y0 = -b * c / (a * a + b * b)

  if c * c > r * r * (a * a + b * b) + eps then
    -- no intersection
    return nil
  elseif c * c - r * r * (a * a + b * b) < eps then
    -- one point intersection
    return { { x = x0, y = y0 } }
  end

  -- two points intersection
  local d = r * r - c * c / (a * a + b * b)
  local mult = math.sqrt(d / (a * a + b * b))

  return { { x = x0 + b * mult, y = y0 - a * mult },
    { x = x0 - b * mult, y = y0 + a * mult } }
end

-- Calls the function `circle_line_intersection_origin` after translating the problem to the origin.
function geometry_utils.circle_line_intersection(circle, a, b, c)
  assert(circle.center and circle.center.x and circle.center.y and circle.radius,
    "variable circle is not a circle")

  local translate = { x = -circle.center.x, y = -circle.center.y }
  -- a and b won't change due to the slope not changing.
  -- c will change by `-a * translate.x - translate.y`.
  local res = circle_line_intersection_origin(circle.radius, a, b, c - a * translate.x - translate.y)

  if res == nil then
    return res
  end

  for _, pt in ipairs(res) do
    pt.x = pt.x - translate.x
    pt.y = pt.y - translate.y
  end

  return res
end

-- Returns the intersection of circle with the line that has equation `x = a`.
function geometry_utils.circle_vertical_line_intersection(circle, a)
  if math.abs(a - circle.center.x) > circle.radius + eps then
    return nil
  end

  local dx = a - circle.center.x
  local dy = math.sqrt(circle.radius * circle.radius - dx * dx)

  return { { x = circle.center.x + dx, y = circle.center.y + dy },
    { x = circle.center.x + dx, y = circle.center.y - dy } }
end

-- Returns the intersection of circle with the line that has equation `y = a`.
function geometry_utils.circle_horizontal_line_intersection(circle, a)
  if math.abs(a - circle.center.y) > circle.radius + eps then
    return nil
  end

  local dy = a - circle.center.y
  local dx = math.sqrt(circle.radius * circle.radius - dy * dy)

  return { { x = circle.center.x + dx, y = circle.center.y + dy },
    { x = circle.center.x - dx, y = circle.center.y + dy } }
end

-- Returns the intersection of circle with segment lying on line `x = a`, starting at y = `start` and
-- ending at y = `end`
function geometry_utils.circle_vertical_segment_intersection(circle, a, start, finish)
  local res = geometry_utils.circle_vertical_line_intersection(circle, a)
  if res == nil then
    return res
  end

  local ans = {}

  for _, pt in ipairs(res) do
    if pt.y >= start and pt.y <= finish then
      table.insert(ans, pt)
    end
  end

  return ans
end

-- Returns the intersection of circle with segment lying on line `y = a`, starting at x = `start` and
-- ending at x = `end`
function geometry_utils.circle_horizontal_segment_intersection(circle, a, start, finish)
  local res = geometry_utils.circle_horizontal_line_intersection(circle, a)
  if res == nil then
    return res
  end

  local ans = {}

  for _, pt in ipairs(res) do
    if pt.x >= start and pt.x <= finish then
      table.insert(ans, pt)
    end
  end

  return ans
end

-- Returns intersection points of circle `c` and rectangle `r`.
-- It's assumed that the rectangle is an AABB.
function geometry_utils.circle_rectangle_intersection(circle, rect)
  assert_circle(circle, "circle")
  assert_rect(rect, "rect")

  local ans = {}

  utils.array_concat(ans,
    geometry_utils.circle_horizontal_segment_intersection(circle, rect.y, rect.x, rect.x + rect.width) or {})

  utils.array_concat(ans,
    geometry_utils.circle_horizontal_segment_intersection(
      circle, rect.y + rect.height, rect.x, rect.x + rect.width) or {})

  utils.array_concat(ans,
    geometry_utils.circle_vertical_segment_intersection(circle, rect.x, rect.y, rect.y + rect.height) or {})

  utils.array_concat(ans,
    geometry_utils.circle_horizontal_segment_intersection(
    circle, rect.x + rect.width, rect.y, rect.y + rect.height) or {})

  return ans
end

return geometry_utils
