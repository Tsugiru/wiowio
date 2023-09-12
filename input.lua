input = {
  observers = {}
}

function input:addObserver(o)
  table.insert(self.observers, o)
end

function input:keyPressed(key)
  for _, v in ipairs(self.observers) do
    if v['onKeyPressed'] ~= nil then
      v:onKeyPressed(key)
    end
  end
end

function input:keyReleased(key)
  for _, v in ipairs(self.observers) do
    if v['onKeyReleased'] ~= nil then
      v:onKeyReleased(key)
    end
  end
end

function input:mousePressed(x, y, button)
  for _, v in ipairs(self.observers) do
    if v['onMousePressed'] ~= nil then
      v:onMousePressed(x, y, button)
    end
  end
end

return input
