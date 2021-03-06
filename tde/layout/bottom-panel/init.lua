--[[
--MIT License
--
--Copyright (c) 2019 manilarome
--Copyright (c) 2020 Tom Meyers
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.
]]
local beautiful = require("beautiful")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi
local signals = require("lib-tde.signals")

local bottom_panel = function(screen)
  local action_bar_height = dpi(45) -- 48

  local panel =
    wibox {
    screen = screen,
    height = action_bar_height,
    width = screen.geometry.width,
    x = screen.geometry.x,
    y = (screen.geometry.y + screen.geometry.height) - action_bar_height,
    ontop = true,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }

  -- this is called when we need to update the screen
  signals.connect_refresh_screen(
    function()
      print("Refreshing bottom-panel")
      local scrn = panel.screen
      panel.x = scrn.geometry.x
      panel.y = (scrn.geometry.y + scrn.geometry.height) - action_bar_height
      panel.width = scrn.geometry.width
      panel.height = action_bar_height
    end
  )

  panel:struts(
    {
      bottom = action_bar_height
    }
  )

  panel:setup {
    layout = wibox.layout.align.vertical,
    require("layout.bottom-panel.action-bar")(screen, action_bar_height)
  }
  return panel
end

return bottom_panel
