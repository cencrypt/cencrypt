local ReplicatedStorage = game:GetService("ReplicatedStorage")

local moduleFolderName = "cencrypt modules"

local modules = ReplicatedStorage:FindFirstChild(moduleFolderName)

if modules ~= nil then
    modules:Destroy()
end

modules = Instance.new("Folder", ReplicatedStorage)
modules.Name = moduleFolderName

local function makeModule(name, url)
    local module = Instance.new("ModuleScript", modules)
    module.Name = name
    module.Source = game:GetService("HttpService"):GetAsync(url)
    return module
end

makeModule("AES", "https://raw.githubusercontent.com/idiomic/Lua_AES/master/AES.lua") -- thanks tyler <3
makeModule("LoadModules", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/LoadModules.lua")
makeModule("CharsBytes", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/CharsBytes.lua")
makeModule("GUID", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/GUID.lua")
makeModule("ScriptWrapper", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/ScriptWrapper.lua")

local AES, LoadModules, CharsBytes, GUID -- so there are none of those annoying "undefined variable" warnings in vscode

require(modules:WaitForChild("LoadModules"))()

local key = tostring("testkey")
print(CharsBytes)
print(CharsBytes.charsToBytes)
local keyBytes = CharsBytes.charsToBytes(key, "")

local function quickEncrypt(str)
    return AES.ECB_256(AES.encrypt, keyBytes, str)
end

local gameData = ""

local function writeData(...)
    gameData = table.concat({gameData, ...}, "")
end

local targetServices = {"Workspace", "Lighting", "ReplicatedFirst", "ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterGui", "StarterPack", "Teams", "SoundService", "Chat"}
local ignoredClassNames = {}


local function getServiceChildren(service)
    local children = game:GetService(service):GetChildren()
    local filtered = {}
    for _, child in pairs(children) do
        if child ~= modules then
            local ignored = false
            for _, className in pairs(ignoredClassNames) do
                if className == child.ClassName then
                    ignored = true
                    break
                end
            end
            if ignored == false then
                table.insert(filtered, child)
            end
        end
    end
    return filtered
end

warn("Untargeting empty services...")

local goodServices = {}

for _, service in pairs(targetServices) do
    if #getServiceChildren(service) > 0 then
        table.insert(goodServices, service)
    end
end

targetServices = goodServices

warn("Grabbing services' children...")

local servicesChildren = {}

for _, service in pairs(targetServices) do
    servicesChildren[service] = getServiceChildren(service)
end

warn("Giving instances a unique identifier...")

local instances = {
    servicesChildren = {},
    descendants = {}
}

for service, child in pairs(servicesChildren) do
    local guid = GUID.makeModule()
    instances.descendants[guid] = {
        Name = child.Name
    }
    child.Name = guid
    if servicesChildren[service]  == nil then
        servicesChildren[service] = {}
    end
    table.insert(servicesChildren[service], guid)
    for _, inst in pairs(child:GetDescendants()) do
        local guid = GUID.makeModule()
        instances.descendants[guid] = {
            Name = inst.Name
        }
        inst.Name = guid
    end
end

