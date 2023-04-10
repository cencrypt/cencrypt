local modules = game:GetService("ReplicatedStorage"):WaitForChild("cencrypt modules")

local ScriptWrapper = require(modules:WaitForChild("ScriptWrapper"))

local classNameProps = {
	{
		{"Part", "CornerWedgePart", "MeshPart", "TrussPart", "WedgePart", "SpawnLocation"},
		{
			Size = Vector3.new(),
			Position = Vector3.new(),
			Rotation = Vector3.new(),
			Anchored = true,
			CanCollide = false,
			Transparency = 1
		}
	},
	{
		{"MeshPart"},
		{
			MeshId = ""
		}
	},
	{
		{"TextLabel", "TextBox"},
		{
			Text = "cencrypt lol"
		}
	}
}

local function checkClassName(inst, classNames)
	local isClassName = false
	for _, className in pairs(classNames) do
		if inst.ClassName == className then
			isClassName = true
			break
		end
	end
	return isClassName
end

local function valToString(val)
	local typ = typeof(val)
	if typ == "Vector3" then
		return "VEC3!" .. tostring(val)
	elseif typ == "boolean" then
		return "BOOL!" .. tostring(val)
	elseif typ == "string" then
		return "STR!" .. tostring(val)
	elseif typ == "number" then
		return "NUM!"  .. tostring(val)
	elseif typ == "Color3" then
		return "CLR3!"  .. tostring(val)
	end
	return
end

local function covInst(inst, quickEncrypt)
	local changedData = {}
	for _, propC in pairs(classNameProps) do
		if checkClassName(inst, propC[1]) then
			for prop, val in pairs(propC[2]) do
				if typeof(inst[prop]) == typeof(val) then
					changedData[prop] = valToString(inst[prop])
					inst[prop] = val
				end
			end
		elseif checkClassName(inst, {"Script", "LocalScript", "ModuleScript"}) then
			if inst ~= game:GetService("ServerStorage"):FindFirstChildWhichIsA("Script") then
				print(inst, "E")
			end
		end
	end
	return changedData
end

local function deCovInst(inst)
	
end

return {
	covInst = covInst,
	deCovInst = deCovInst
}