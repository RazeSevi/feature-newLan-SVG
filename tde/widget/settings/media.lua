local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local rounded = require("lib-tde.widget.rounded")
local icons = require("theme.icons")

local dpi = beautiful.xresources.apply_dpi

local m = dpi(10)
local settings_index = dpi(40)

return function()
  local view = wibox.container.margin()
  view.left = m
  view.right = m

  local title = wibox.widget.textbox("Media")
  title.font = beautiful.title_font
  title.forced_height = settings_index + m + m

  local close = wibox.widget.imagebox(icons.close)
  close.forced_height = dpi(30)
  close:buttons(
    gears.table.join(
      awful.button(
        {},
        1,
        function()
          if root.elements.settings then
            root.elements.settings.close()
          end
        end
      )
    )
  )

  local vol_heading = wibox.widget.textbox("Volume")
  vol_heading.font = beautiful.font

  local vol_footer = wibox.widget.textbox("test")
  vol_footer.font = beautiful.font
  vol_footer.align = "right"

  local mic_footer = wibox.widget.textbox("test")
  mic_footer.font = beautiful.font
  mic_footer.align = "right"

  local vol_slider = wibox.widget.slider()
  vol_slider.bar_shape = function(c, w, h)
    gears.shape.rounded_rect(c, w, h, dpi(30) / 2)
  end
  vol_slider.bar_height = dpi(30)
  vol_slider.bar_color = beautiful.bg_modal
  vol_slider.bar_active_color = beautiful.accent.hue_500
  vol_slider.handle_shape = gears.shape.circle
  vol_slider.handle_width = dpi(35)
  vol_slider.handle_color = beautiful.accent.hue_500
  vol_slider.handle_border_width = 1
  vol_slider.handle_border_color = "#00000012"
  vol_slider.minimum = 0
  vol_slider.maximum = 100
  vol_slider:connect_signal(
    "property::value",
    function()
      awful.spawn.with_shell("tos volume set " .. tostring(vol_slider.value))
    end
  )

  awesome.connect_signal(
    "widget::volume:update",
    function(value)
      vol_slider:set_value(tonumber(value))
    end
  )

  view.refresh = function()
    awful.spawn.easy_async_with_shell(
      'pactl list sinks | grep "Active Port:" | awk \'{print $3}\'',
      function(o)
        if o then
          vol_footer.markup =
            'Output: <span font="' .. beautiful.font .. '">' .. o:gsub("^%s*(.-)%s*$", "%1") .. "</span>"
        end
      end
    )

    awful.spawn.easy_async_with_shell(
      'pactl list sources | grep "Active Port:" | awk \'{print $3}\'',
      function(o, e)
        if o then
          mic_footer.markup =
            'Input: <span font="' .. beautiful.font .. '">' .. o:gsub("^%s*(.-)%s*$", "%1") .. "</span>"
        end
      end
    )

    awful.spawn.easy_async_with_shell(
      "bash -c 'amixer -D pulse sget Master'",
      function(stdout)
        local mute = string.match(stdout, "%[(o%D%D?)%]")
        local volume = string.match(stdout, "(%d?%d?%d)%%")
        vol_slider:set_value(tonumber(volume))
      end
    )
  end

  view:setup {
    layout = wibox.container.background,
    {
      layout = wibox.layout.fixed.vertical,
      spacing = m,
      {
        layout = wibox.layout.align.horizontal,
        nil,
        {
          layout = wibox.container.place,
          title
        },
        close
      },
      {
        layout = wibox.container.background,
        bg = beautiful.bg_modal,
        shape = rounded(),
        {
          layout = wibox.layout.fixed.vertical,
          {
            layout = wibox.container.margin,
            margins = m,
            {
              layout = wibox.layout.align.horizontal,
              vol_heading,
              nil,
              mute
            }
          },
          {
            layout = wibox.container.margin,
            left = m,
            right = m,
            bottom = m,
            forced_height = dpi(30) + (m * 2),
            vol_slider
          },
          {
            layout = wibox.container.margin,
            left = m,
            right = m,
            vol_footer
          },
          {
            layout = wibox.container.margin,
            left = m,
            right = m,
            bottom = m,
            mic_footer
          }
        }
      }
    }
  }

  return view
end