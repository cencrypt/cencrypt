local modules = script.Parent

require(modules:WaitForChild("LoadModules"))({script})

local classNameProps = {
    {
        {"Part", "CornerWedgePart", "MeshPart", "TrussPart", "WedgePart"},
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

local function covInst(inst, id)
    local changedData = {}
    for _, propC in pairs(classNameProps) do
        if checkClassName(inst, propC[1]) then
            if changedData[id] == nil then
                changedData[id] = {}
            end
            for prop, val in pairs(propC) do
                if typeof(inst[prop]) == typeof(val) then
                    local sval = valToString(val)
                    changedData[id][prop] = sval
                end
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