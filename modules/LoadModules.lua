local modules = script.Parent

return function()
    for _, module in pairs(modules) do
        getfenv(2)[module.Name] = require(module)
    end
end