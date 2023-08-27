-- `image`: The image from which the animation frames will be chosen.
-- `sprite_width`, `sprite_height`: Width and height of the sprite to be animated.
-- `row`: The 0-based index of the row on which the animation frames will be selected.
-- `start_column`, `end_column`: 0-based indices of columns in the spritesheet corresponding to the given row.
-- `duration`: The duration of the animation.
return function(image, sprite_width, sprite_height, row, start_column, end_column, duration)
  local animation = {
    elapsed_time = 0,
    quads = {}
  }

  for col = start_column, end_column do
    table.insert(animation.quads,
      love.graphics.newQuad(
        col * sprite_width,
        row * sprite_height,
        sprite_height,
        sprite_width,
        image))
  end

  function animation:animate(dt)
    self.elapsed_time = self.elapsed_time + dt
    if self.elapsed_time > duration then
      self.elapsed_time = self.elapsed_time - duration
    end
  end

  -- `x`, `y`: x and y position to draw the animation at.
  function animation:draw(x, y)
    love.graphics.draw(image,
      self.quads[math.floor((self.elapsed_time / duration) * #self.quads) + 1],
      x, y)
  end

  return animation
end

