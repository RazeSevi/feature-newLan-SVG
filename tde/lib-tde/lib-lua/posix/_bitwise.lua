--[[
 POSIX library for Lua 5.1, 5.2 & 5.3.
 Copyright (C) 2020 Gary V. Vaughan
]]
--[[--
 Private argument checking lib-tdes.

 Undocumented internal lib-tdes for bitwise operations on Lua 5.3+.

 @module posix._bitwise
]]


return {
   band = function(a, ...)
      for _, v in next, {...} do
        a = a & v
      end
      return a
   end,

   bor = function(a, ...)
      for _, v in next, {...} do
        a = a | v
      end
      return a
   end,

   bnot = function(a) return ~a end,
}