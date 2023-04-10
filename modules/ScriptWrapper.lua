local modules = script.Parent

local AES = require(modules:WaitForChild("AES"))
local CharsBytes = require(modules:WaitForChild("CharsBytes"))

local function wrapScript(scr, quickEncrypt)
    local src = scr.Source
    local srcSecure = quickEncrypt(src)
    local srcBytes = CharsBytes.charsToBytes(srcSecure)
    return table.concat(
        {
			'local ScriptWrapper = require(game:GetService("ReplicatedStorage"):WaitForChild(require(game:WaitForChild("Data")).moduleFolderName):WaitForChild("ScriptWrapper"))\n' ,
            'return loadstring(ScriptWrapper.unwrapScript("', srcBytes, '")()'
        }, "")
end


local function unwrapScript(str)
    local key = require(game:WaitForChild("Data")).key
    local strChars = CharsBytes.bytesToChars(str)
    local src = AES.ECB_256(AES.decrypt, key, strChars)
    return src
end

return {
    wrapScript = wrapScript,
    unwrapScript = unwrapScript
}