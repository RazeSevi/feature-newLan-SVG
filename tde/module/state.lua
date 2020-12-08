-- This module listens for events and stores then
-- This makes certain data persistant

local signals = require("lib-tde.signals")
local serialize = require("lib-tde.serialize")
local filehandle = require("lib-tde.file")

local file = os.getenv("HOME") .. "/.cache/tde/settings_state.json"

local function load()
    local table = {
        volume = 0,
        brightness = 100
    }
    if not filehandle.exists(file) then
        return table
    end
    return serialize.deserialize_from_file(file)
end

local function save(table)
    serialize.serialize_to_file(table)
end

local function setup_state(state)
    -- set the volume
    print("Setting volume: " .. state.volume)
    awful.spawn("amixer -D pulse sset Master " .. tostring(state.volume or 0) .. "%")
    signals.emit_volume_update()

    -- set the brightness
    if (_G.oled) then
        awful.spawn("brightness -s " .. math.max(state.brightness, 5) .. " -F") -- toggle pixel values
    else
        awful.spawn("brightness -s 100 -F") -- reset pixel values
        awful.spawn("brightness -s " .. math.max(state.brightness, 5))
    end

    -- execute xrandr script
    awful.spawn("which autorandr && autorandr --load tde")
end

-- load the initial state
local save_state = load()
setup_state(save_state)

-- listen for events and store the state on those events

signals.connect_volume(
    function(value)
        save_state.volume = value
        save(save_state)
    end
)

signals.connect_brightness(
    function(value)
        print("Brightness value: " .. value)
        save_state.brightness = value
        save(save_state)
    end
)

signals.connect_exit(
    function()
        print("Shutting down, grabbing last state")
        awful.spawn("which autorandr && autorandr --save tde")
        save(table)
    end
)
