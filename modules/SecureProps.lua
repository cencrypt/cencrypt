local modules = script.Parent

local ScriptWrapper = require(modules:WaitForChild("ScriptWrapper"))
local CharsBytes = require(modules:WaitForChild("CharsBytes"))

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
		{"TextLabel", "TextBox"},
		{
			Text = "cencrypt lol"
		}
	},
    {
        {"Script", "LocalScript"},
        {
            Enabled = false
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

local function svalToVal(sval)

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
		end
	end
	if checkClassName(inst, {"Script", "LocalScript", "ModuleScript"}) then
		if inst ~= game:GetService("ServerStorage"):FindFirstChildWhichIsA("Script") then
			inst.Source = ScriptWrapper.wrapScript(inst, quickEncrypt)
		end
	end
	return changedData
end

local function deCovInst(inst, id, quickDecrypt)
	local data = require(game:WaitForChild("Data"))
	local props = data.descendants[id]
	if props then
		for prop, sval in pairs(props) do
			local sval = quickDecrypt(CharsBytes.bytesToChars(sval))

		end
	end
end

return {
	covInst = covInst,
	deCovInst = deCovInst
}