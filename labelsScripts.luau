local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local module = {}
local labelsEnabled = false
local connections = {}
local createdLabels = {}

local function getAttachPart(character)
    return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

local function removeLabel(character)
    local label = createdLabels[character]
    if label then
        label:Destroy()
        createdLabels[character] = nil
    end
end

local function createLabelForCharacter(character)
    if not labelsEnabled then return end
    local attach = getAttachPart(character)
    if not attach then return end
    removeLabel(character)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "AqwozHubLabel"
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 300
    billboard.ResetOnSpawn = false
    billboard.Parent = attach
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0.5
    text.TextScaled = false
    text.Font = Enum.Font.GothamBold
    text.TextSize = 16
    text.Text = tostring(character.Parent.Name)
    text.Parent = billboard
    createdLabels[character] = billboard
end

local function setupPlayer(player)
    if player == Players.LocalPlayer then return end
    if connections[player] then connections[player]:Disconnect() end
    connections[player] = player.CharacterAdded:Connect(function(char)
        if labelsEnabled then createLabelForCharacter(char) end
    end)
    if player.Character and labelsEnabled then
        createLabelForCharacter(player.Character)
    end
end

function module.init()
    for _, plr in ipairs(Players:GetPlayers()) do
        setupPlayer(plr)
    end
    connections["added"] = Players.PlayerAdded:Connect(function(plr)
        setupPlayer(plr)
    end)
    connections["removing"] = Players.PlayerRemoving:Connect(function(plr)
        if connections[plr] then
            connections[plr]:Disconnect()
            connections[plr] = nil
        end
    end)
end

function module.toggleLabels(state)
    labelsEnabled = state and true or false
    if not labelsEnabled then
        for char, _ in pairs(createdLabels) do
            removeLabel(char)
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer and plr.Character then
            createLabelForCharacter(plr.Character)
        end
    end
end

function module.destroy()
    labelsEnabled = false
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}
    for char, _ in pairs(createdLabels) do
        removeLabel(char)
    end
end

return module
