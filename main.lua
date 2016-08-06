#!/usr/bin/env luajit

local function where_is_main_dot_lua()
    local function string_split(self, sep)
        local fields = {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(self, pattern, function(c) fields[#fields+1] = c end)
        return fields
    end

    local components = string_split(arg[0], '/')
    components[#components] = nil
    return table.concat(components, '/')
end

local folder = where_is_main_dot_lua()
local target = arg[1] or 'default'

package.path = package.path..';'..folder..'/?.lua'
package.path = package.path..';'..folder..'/?/init.lua'

require('include/init')

dofile('targets.lua')
local f = _G[target]
if f then
    local x = {...}
    table.remove(x, 1)
    local success, err = pcall(f, unpack(x))
    if not success then
        print(RED("ERROR: ")..err)
    end
else
    print("No function for '"..target.."' found :(")
end

if cleanup then
    cleanup(...)
end

if #arg > 1 then
    print(GREEN("Ignore the following error, it's just a limitation of Makefiles:"))
end
