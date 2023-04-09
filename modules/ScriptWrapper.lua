local modules = script.Parent

local CharsBytes-- so there are none of those annoying "undefined variable" warnings in vscode

require(modules:WaitForChild("LoadModules"))()

local function wrapScript(scr, quickEncrypt)
    local src = scr.Source
    local srcSecure = quickEncrypt(src)
    local srcBytes = CharsBytes.charsToBytes(srcSecure)
    return table.concat(
        {
            'game:GetService("ReplicatedStorage"):WaitForChild("', modules.Name, '"):WaitForChild("LoadModules")\n' ,
            'return loadstring(ScriptWrapper.unwrapScript("', srcBytes, '")()'
        }, "")
end


local function unwrapScript(str)
    local Data = require(game:WaitForChild("Data"))
end

return {
    wrapScript = wrapScript
}