-- Main monitors
local function has_laptop_display()
  local monitors = hl.get_monitors()
  for _, name in ipairs(monitors) do
    if string.find(name.description, 'AU Optronics 0x229E') then
      return true
    end
  end
  return false
end

local is_laptop = has_laptop_display()

hl.monitor {
  output = 'desc: Samsung Electric Company U28E850 \\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff',
  mode = '3840x2160@60',
  -- position = '3840x0',
  position = (is_laptop and '3840' or '1920') .. 'x0',
  scale = '1.5',
}

hl.monitor {
  output = 'desc: Eizo Nanao Corporation EV2436W 42038045',
  mode = '1920x1200@60',
  position = (is_laptop and '1920' or '0') .. 'x0',
  scale = '1',
}

-- Laptop monitor
hl.monitor {
  output = 'desc: AU Optronics 0x229E',
  mode = '1920x1080@60',
  position = '0x0',
  scale = '1',
}

-- Wildcard for randomly plugged in monitors like projectors
hl.monitor {
  output = '',
  mode = 'preferred',
  position = 'auto',
  scale = '1',
}
