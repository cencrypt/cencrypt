local GUIDs = {}

local function makeGUID()
    local guid = game:GetService("HttpService"):GenerateGUID(false)
    if GUIDs[guid] then
        return makeGUID()
    end
    GUIDs[guid] = true
    return guid
end

return {
    makeGUID = makeGUID
}