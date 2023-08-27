input = {
  observers = {}
}

function input:addObserver(o)
  table.insert(self.observers, o)
end

function input:keyPressed(key)
  for _, v in ipairs(self.observers) do
    v:onKeyPressed(key)
  end
end

function input:keyReleased(key)
  for _, v in ipairs(self.observers) do
    v:onKeyReleased(key)
  end
end

return input
