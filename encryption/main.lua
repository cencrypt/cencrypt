if false then
    -- use in command bar to execute script
    loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/encryption/main.lua"))()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = Instance.new("Folder", ReplicatedStorage)
modules.Name = "cencrypt modules"

local function makeModule(name, url)
    local module = Instance.new("ModuleScript", modules)
    module.Name = name
    module.Source = game:GetService("HttpService"):GetAsync(url)
    return module
end