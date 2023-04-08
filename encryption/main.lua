

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = Instance.new("Folder", ReplicatedStorage)
modules.Name = "cencrypt modules"

local function makeModule(name, url)
    local module = Instance.new("ModuleScript", modules)
    module.Name = name
    module.Source = game:GetService("HttpService"):GetAsync(url)
    return module
end

makeModule