local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = Instance.new("Folder", ReplicatedStorage)
modules.Name = "cencrypt modules"

local function makeModule(name, url)
    local module = Instance.new("ModuleScript", modules)
    module.Name = name
    module.Source = game:GetService("HttpService"):GetAsync(url)
    return module
end

makeModule("AES", "https://raw.githubusercontent.com/idiomic/Lua_AES/master/AES.lua") -- thanks tyler <3
makeModule("LoadModules", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/LoadModules.lua")
makeModule("CharBytes", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/CharsBytes.lua")

require(modules:WaitForChild("LoadModules"))()

print(CharBytes)