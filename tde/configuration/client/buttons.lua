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
local modkey = require("configuration.keys.mod").modKey

local function getButtons()
  return awful.util.table.join(
    awful.button(
      {},
      1,
      function(c)
        -- TODO: figure out a way to allow all on screen keyboards to work properly
        -- only raise the focus if the app is not onboard
        if c.name ~= "Onboard" and c.name ~= "onboard" then
          _G.client.focus = c
          c:raise()
        end
      end
    ),
    awful.button(
      {modkey},
      1,
      function(c)
        c:activate {context = "mouse_click", action = "mouse_move"}
      end
    ),
    awful.button(
      {modkey},
      3,
      function(c)
        c:activate {context = "mouse_click", action = "mouse_resize"}
      end
    )
  )
end

client.connect_signal(
  "request::default_mousebindings",
  function()
    awful.mouse.append_client_mousebindings(
      {
        awful.button(
          {modkey},
          1,
          function(c)
            c:activate {context = "mouse_click", action = "mouse_move"}
          end
        ),
        awful.button(
          {modkey},
          3,
          function(c)
            c:activate {context = "mouse_click", action = "mouse_resize"}
          end
        )
      }
    )
  end
)

return getButtons()
