game:GetService("Players").CharacterAutoLoads = false

Instance.new("Script", game:GetService("ServerScriptService")).Source = game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/decryption/server.lua")
Instance.new("LocalScript", game:GetService("ReplicatedFirst")).Source = game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/cencrypt/cencrypt/v0.3/decryption/client.lua")
