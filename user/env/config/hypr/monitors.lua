-- Main monitors

hl.monitor {
  output = 'desc: Samsung Electric Company U28E850 \\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff',
  mode = '3840x2160@60',
  position = '1920x0',
  scale = '1.5',
}

hl.monitor {
  output = 'desc: Eizo Nanao Corporation EV2436W 42038045',
  mode = '1920x1200@60',
  position = '0x0',
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
