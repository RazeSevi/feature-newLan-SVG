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
local wibox = require("wibox")
local clickable_container = require("widget.action-center.clickable-container")
local gears = require("gears")
local dpi = require("beautiful").xresources.apply_dpi
local mat_list_item = require("widget.material.list-item")

local PATH_TO_ICONS = "/etc/xdg/tde/widget/action-center/icons/"
local config = require("config")

local cmd = 'grep -F \'"glx";\' ' .. config.getComptonFile() .. "| tr -d '[\\-\\;\\=\\ ]' "
local frameStatus
local widgetIconName

-- Image wibox

local widget =
  wibox.widget {
  {
    id = "icon",
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local function update_icon()
  if frameStatus then
    widgetIconName = "toggled-on"
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. ".svg")
  else
    widgetIconName = "toggled-off"
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. ".svg")
  end
end

------

-- The cmd variable is declared above
-- It checks the line "blur-background-frame: false;"
-- I use 'tr' shell command to remove the special characters
-- because lua is choosy on MATCH method
-- So the output will be 'blurbackgroundframefalse'
-- if it matches the assigned value inside the match method below
-- then it will declared as value of frameCheker
-- The rest is history
local frameChecker
local function checkFrame()
  awful.spawn.easy_async_with_shell(
    cmd,
    function(stdout)
      print("Compositor backend: " .. stdout)
      frameChecker = stdout:match('backend"glx"')
      if frameChecker == nil then
        frameStatus = false
        update_icon()
      else
        frameStatus = true
        update_icon()
      end
    end
  )
end

-- Commands that will be executed when I toggle the button
local glxDisable = {
  'sed -i -e \'s/"glx";/"xrender";/g\' ' .. config.getComptonFile(),
  "picom -b --dbus --experimental-backends --config " .. config.getComptonFile(),
  'notify-send "Xrenderer backend enabled"'
}
local glxEnable = {
  'sed -i -e \'s/"xrender";/"glx";/g\' ' .. config.getComptonFile(),
  "picom -b --dbus --experimental-backends --config " .. config.getComptonFile(),
  'notify-send "GLX effect enabled"'
}

local function run_once(glxCmd)
  local findme = glxCmd
  local firstspace = glxCmd:find(" ")
  if firstspace then
    findme = glxCmd:sub(0, firstspace - 1)
  end
  print("Running command: " .. string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, glxCmd))
  awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, glxCmd))
end

local function toggle_compositor()
  if (frameStatus == true) then
    awful.spawn.with_shell("kill -9 $(pidof picom)")
    for _, app in ipairs(glxDisable) do
      run_once(app)
    end
    frameStatus = false
    update_icon()
  else
    awful.spawn.with_shell("kill -9 $(pidof picom)")
    for _, app in ipairs(glxEnable) do
      run_once(app)
    end
    frameStatus = true
    update_icon()
  end
end

checkFrame()
-----------------------------------------------------------------------------------------------------------------

local compton_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7))) -- 4 is top and bottom margin
compton_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_compositor()
      end
    )
  )
)

local settingsName =
  wibox.widget {
  text = "Accelerated graphics composition",
  font = "Iosevka Regular 10",
  align = "left",
  widget = wibox.widget.textbox
}

local content =
  wibox.widget {
  settingsName,
  compton_button,
  bg = "#ffffff20",
  shape = gears.shape.rounded_rect,
  widget = wibox.container.background(settingsName),
  layout = wibox.layout.ratio.horizontal
}
content:set_ratio(1, .85)

local comptonButton =
  wibox.widget {
  wibox.widget {
    content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}

return comptonButton
