-- Import lemur
package.path = package.path .. ";?/init.lua"
local lemur = require("modules.lemur")

local habitat = lemur.Habitat.new()

-- Services
local ReplicatedStorage = habitat.game:GetService("ReplicatedStorage")

-- Utility Functions
local function newFolder(name, parent, content)
	local folder
	if content then
		folder = habitat:loadFromFs(content)
	else
		folder = lemur.Instance.new("Folder")
	end

	folder.Name = name
	folder.Parent = parent

	return folder
end

-- polyfill for table.create - lemur doesn't support this yet.
function table.create(size, value) -- luacheck: ignore
	local t = {}
	for i = 1, size do
		t[i] = value
	end
	return t
end

-- pollyfill for table.find - lemur doesn't support this just yet
function table.find(t, value, init) -- luacheck: ignore
	for i = init or 1, #t do
		if t[i] == value then
			return i
		end
	end

	return nil
end

-- Roblox TS Stuff
local robloxTsFolder = newFolder("include", ReplicatedStorage, "include")

-- Modules
newFolder("node_modules", robloxTsFolder, "../node_modules/@rbxts")

-- TestEZ
local testEZFolder = newFolder("TestEZ", ReplicatedStorage, "modules/testez/src")

-- Testing code
local testsFolder = newFolder("src", ReplicatedStorage, "src")

-- Load TestEZ and run our tests
local TestEZ = habitat:require(testEZFolder)

local results = TestEZ.TestBootstrap:run({testsFolder}, TestEZ.Reporters.TextReporter)

-- Did something go wrong?
if #results.errors > 0 or results.failureCount > 0 then
	os.exit(1)
end