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
makeModule("CharsBytes", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/CharsBytes.lua")
makeModule("GUID", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/GUID.lua")
makeModule("ScriptWrapper", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/ScriptWrapper.lua")
makeModule("SecureProps", "https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/modules/SecureProps.lua")

local AES = require(modules:WaitForChild("AES"))
local CharsBytes = require(modules:WaitForChild("CharsBytes"))
local GUID = require(modules:WaitForChild("GUID"))
local ScriptWrapper = require(modules:WaitForChild("ScriptWrapper"))
local SecureProps = require(modules:WaitForChild("SecureProps"))

local key = tostring("testkey")
local keyBytes = CharsBytes.charsToBytes(key, "")

local function quickEncrypt(str)
	return AES.ECB_256(AES.encrypt, keyBytes, str)
end

local targetServices = {"Workspace", "Lighting", "ReplicatedFirst", "ReplicatedStorage", "ServerScriptService", "ServerStorage", "StarterGui", "StarterPack", "Teams", "SoundService", "Chat"}
local ignoredClassNames = {}

local CEN = game:FindFirstChild("CEN")

if CEN ~= nil then
	CEN:Destroy()
end

CEN = Instance.new("Folder", game)
CEN.Name = "CEN"

local function getServiceChildren(service)
	local children = game:GetService(service):GetChildren()
	local filtered = {}
	for _, child in pairs(children) do
		if child ~= modules and child ~= script then
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

warn("Giving instances a unique identifier and moving children to folder...")

local instances = {
	servicesChildren = {},
	descendants = {}
}

for service, children in pairs(servicesChildren) do
	for _, child in pairs(children) do
		if child.ClassName ~= nil then
			local guid = GUID.makeGUID()
			instances.descendants[guid] = {
				Instance = child,
				Name = child.Name
			}
			child.Name = guid
			if instances.servicesChildren[service]  == nil then
				instances.servicesChildren[service] = {}
			end
			table.insert(instances.servicesChildren[service], guid)
			child.Parent = CEN
			for _, inst in pairs(child:GetDescendants()) do
				local guid = GUID.makeGUID()
				instances.descendants[guid] = {
					Instance = inst,
					Name = inst.Name
				}
				inst.Name = guid
			end
		end
	end
end

warn("Mismatching and securing instance's properties...")
warn("Encrypting scripts...")

for id, inst in pairs(instances.descendants) do
	local changedData = SecureProps.covInst(inst.Instance, quickEncrypt)
	for prop, sval in pairs(changedData) do
		instances.descendants[id][prop] = sval
	end
end

warn("Encrypting and writing data...")

local gameData = ""

local function writeData(...)
	gameData = table.concat({gameData, ...}, "")
end

local function s(str)
	return '"' .. str .. '"'
end

writeData("{sanity=", s(CharsBytes.charsToBytes(quickEncrypt("sanity"))), ";moduleFolderName=", s(CharsBytes.charsToBytes(moduleFolderName)), ";servicesChildren={")

for service, ids in pairs(instances.servicesChildren) do
	writeData(service, "={")
	for _, id in pairs(ids) do
		writeData(s(id), ";")
	end
	writeData("};")
end

writeData("};", "descendants={")

for id, props in pairs(instances.descendants) do
	writeData("[", s(id), "]={")
	for prop, sval in pairs(props) do
		if prop == "Instance" then
			continue
		end
		writeData("[", s(prop), "]=", s(CharsBytes.charsToBytes(quickEncrypt(sval))), ";")
	end
	writeData("};")
end

writeData("};};")

warn("Saving data to module...")

local data = game:FindFirstChild("Data")

if data then
	data:Destroy()
end

data = Instance.new("ModuleScript",game)
data.Name = "Data"
data.Source = "return " .. gameData

warn("Finalizing game...")

loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/decryption/setup.lua"))()