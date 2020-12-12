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
local i18n = require("tde.lib-tde.i18n")
i18n._disable_color()

function test_i18n_functions_exist()
    assert(type(i18n.init) == "function")
    assert(type(i18n.translate) == "function")
    assert(type(i18n.custom_translations) == "function")
    assert(type(i18n.system_language) == "function")
    assert(type(i18n.set_system_language) == "function")
end

function test_i18n_system_language()
    assert(i18n.system_language() == "en")
    i18n.set_system_language("dutch")
    assert(i18n.system_language() == "dutch")
    i18n.set_system_language("en")
    assert(i18n.system_language() == "en")
end

function test_i18n_custome_translations()
    -- we set the language to anything else than english
    -- because translating from english to english is not valid
    i18n.set_system_language("dutch")
    assert(i18n.translate("random") == "random")
    i18n.custom_translations(
        {
            random = "modnar"
        }
    )
    assert(i18n.translate("random") == "modnar")
    i18n.set_system_language("en")
end

function test_init_works()
    -- init the translations with default values
    assert(i18n.init("en"))
    assert(not i18n.init("en"))
end

function test_dutch_translations()
    i18n.set_system_language("nl")
    local home = i18n.translate("home")
    local connection = i18n.translate("Wireless connection")

    i18n.set_system_language("en")
    assert(home == "huis")
    assert(connection == "Draadloze verbinding")
end
