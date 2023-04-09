local modules = script.Parent

require(modules:WaitForChild("LoadModules"))()

local function wrapScript(scr)
    local src = scr.Source
    local srcBytes = CharsBytes.charsToBytes(src)

end

return {
    wrapScript = wrapScript
}