-- Dev Decompiler Executor Version

--[[⚠️ Compatibility Check]]
local clipboardFunc = getclipboard or setclipboard or nil
local canReadSource = true
local executor = identifyexecutor and identifyexecutor() or "Unknown"

-- UI Setup
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DevDecompiler"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 370, 0, 360)
frame.Position = UDim2.new(0.5, -185, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Label
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "Dev Decompiler - Executor: " .. executor
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 28)
dropdown.Position = UDim2.new(0, 10, 0, 35)
dropdown.Text = "Workspace"
dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

-- Search
local searchBox = Instance.new("TextBox", frame)
searchBox.Size = UDim2.new(1, -20, 0, 28)
searchBox.Position = UDim2.new(0, 10, 0, 70)
searchBox.PlaceholderText = "Search script name..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

-- Script list
local scrollingFrame = Instance.new("ScrollingFrame", frame)
scrollingFrame.Size = UDim2.new(1, -20, 0, 160)
scrollingFrame.Position = UDim2.new(0, 10, 0, 105)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scrollingFrame.ScrollBarThickness = 6
Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 8)

-- Copy Button
local copyBtn = Instance.new("TextButton", frame)
copyBtn.Size = UDim2.new(0.8, 0, 0, 35)
copyBtn.Position = UDim2.new(0.1, 0, 1, -45)
copyBtn.Text = "Copy Selected"
copyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 16
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)

-- Dropdown options
local dropdownOptions = {
	"Workspace", "ReplicatedStorage", "ReplicatedFirst",
	"ServerScriptService", "StarterGui", "StarterPack"
}

local function getTarget(name)
	return ({
		Workspace = workspace,
		ReplicatedStorage = game:GetService("ReplicatedStorage"),
		ReplicatedFirst = game:GetService("ReplicatedFirst"),
		ServerScriptService = game:GetService("ServerScriptService"),
		StarterGui = game:GetService("StarterGui"),
		StarterPack = game:GetService("StarterPack")
	})[name]
end

local checkboxes = {}
local allScripts = {}
local currentTarget = workspace

-- Refresh function
local function refreshScripts()
	for _, c in ipairs(scrollingFrame:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	checkboxes = {}
	allScripts = {}

	for _, s in ipairs(currentTarget:GetDescendants()) do
		if s:IsA("Script") or s:IsA("LocalScript") then
			table.insert(allScripts, s)
		end
	end

	local y = 0
	for _, s in ipairs(allScripts) do
		if searchBox.Text == "" or string.find(string.lower(s.Name), string.lower(searchBox.Text)) then
			local btn = Instance.new("TextButton", scrollingFrame)
			btn.Size = UDim2.new(1, -10, 0, 25)
			btn.Position = UDim2.new(0, 5, 0, y)
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Text = "[ ] " .. s:GetFullName()
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.AutoButtonColor = false

			local selected = false
			btn.MouseButton1Click:Connect(function()
				selected = not selected
				btn.Text = selected and "[✔] " .. s:GetFullName() or "[ ] " .. s:GetFullName()
				checkboxes[s] = selected
			end)

			checkboxes[s] = false
			y += 30
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Dropdown
dropdown.MouseButton1Click:Connect(function()
	local index = table.find(dropdownOptions, dropdown.Text) or 1
	index = (index % #dropdownOptions) + 1
	dropdown.Text = dropdownOptions[index]
	currentTarget = getTarget(dropdown.Text)
	refreshScripts()
end)

-- Search listener
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	refreshScripts()
end)

-- Copy logic
copyBtn.MouseButton1Click:Connect(function()
	local output = {}

	for scriptObj, isSelected in pairs(checkboxes) do
		if isSelected then
			local ok, src = pcall(function() return scriptObj.Source end)
			if ok and src then
				table.insert(output, "-- " .. scriptObj:GetFullName() .. ":\n" .. src)
			else
				table.insert(output, "-- " .. scriptObj:GetFullName() .. ":\n[Source Not Accessible]")
			end
		end
	end

	local joined = table.concat(output, "\n\n--======--\n\n")

	if clipboardFunc then
		clipboardFunc(joined)
		copyBtn.Text = "Copied!"
	else
		copyBtn.Text = "Clipboard Unavailable"
	end

	task.wait(2)
	copyBtn.Text = "Copy Selected"
end)

-- Start
refreshScripts()
