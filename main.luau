-- main.luau - Aqwoz Hub (Rayfield Edition)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Module Loader
local function loadModule(path, url)
    -- 1. Try local file
    if isfile and isfile(path) then
        print("[AqwozHub] Found local file: " .. path)
        local success, result = pcall(function()
            return loadstring(readfile(path))()
        end)

        if success then
            print("[AqwozHub] Successfully loaded local module: " .. path)
            return result
        else
            warn("[AqwozHub] Error loading local file: " .. tostring(result))
        end
    end

    -- 2. Fallback to GitHub URL with cache busting
    print("[AqwozHub] Fetching from URL: " .. url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url .. "?t=" .. tostring(math.random(1, 1000000))))()
    end)

    if success then
        print("[AqwozHub] Successfully loaded remote module")
        return result
    else
        warn("[AqwozHub] Critical Error loading module: " .. tostring(result))
        -- Return dummy object to prevent crash
        return {
            init = function() end,
            toggleESP = function() end,
            toggleAimbot = function() end,
            setFOV = function() end,
            setSmoothing = function() end,
            toggleTeamCheck = function() end,
            toggleWallCheck = function() end,
            toggleHoldToAim = function() end,
            toggleFOVCircle = function() end,
            toggleKeyToggle = function() end,
            setToggleKey = function() end,
            setTargetPart = function() end,
            setMaxAngle = function() end,
            setMaxDistance = function() end,
            toggleDynamicSmoothing = function() end,
            togglePointerLock = function() end
        }
    end
end

-- Vision module
local visionScripts = loadModule("visionScripts.luau", "https://raw.githubusercontent.com/AqwozTheDeveloper/AqwozHubLegacyTest/refs/heads/main/AqwozHub-main/visionScripts.luau")
visionScripts.init()

-- Aimbot module
local aimbotScripts = loadModule("aimbotScripts.luau", "https://raw.githubusercontent.com/AqwozTheDeveloper/AqwozHubLegacyTest/refs/heads/main/AqwozHub-main/aimbotScripts.luau")
aimbotScripts.init()
local labelsScripts = loadModule("labelsScripts.luau", "https://raw.githubusercontent.com/AqwozTheDeveloper/AqwozHubLegacyTest/refs/heads/main/AqwozHub-main/labelsScripts.luau")
labelsScripts.init()
local Settings = loadModule("settingsManager.luau", "https://raw.githubusercontent.com/AqwozTheDeveloper/AqwozHubLegacyTest/refs/heads/main/AqwozHub-main/settingsManager.luau")
Settings.init()

-- Window
local Window = Rayfield:CreateWindow({
    Name = "Aqwoz Hub",
    LoadingTitle = "Aqwoz Hub",
    LoadingSubtitle = "by AqwozTheDeveloper",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "AqwozHubConfig",
       FileName = "AqwozHub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
})

-- Notification
Rayfield:Notify({
   Title = "Welcome to AqwozHub",
   Content = "Script loaded successfully! Testing version.",
   Duration = 5,
   Image = 4483362458,
})

-- Tabs
local MainTab = Window:CreateTab("Home", 4483362458) -- Title, Image
local VisionTab = Window:CreateTab("Visuals", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)

-- Home Tab
MainTab:CreateParagraph({Title = "Welcome!", Content = "Hello, this script is developed by Aqwoz. Updates are on the way."})

-- Vision Tab
VisionTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = Settings.get("ESPToggle") == true,
   Flag = "ESPToggle", -- A flag is the identifier for the configuration file
   Callback = function(Value)
        visionScripts.toggleESP(Value)
        Settings.set("ESPToggle", Value)
   end,
})

VisionTab:CreateToggle({
   Name = "Show Player Labels",
   CurrentValue = Settings.get("LabelsToggle") == true,
   Flag = "LabelsToggle",
   Callback = function(Value)
        labelsScripts.toggleLabels(Value)
        Settings.set("LabelsToggle", Value)
   end,
})

-- Combat Tab
CombatTab:CreateSection("Aimbot Settings")

CombatTab:CreateToggle({
   Name = "Enable Aimbot",
   CurrentValue = Settings.get("AimbotToggle") == true,
   Flag = "AimbotToggle",
   Callback = function(Value)
        aimbotScripts.toggleAimbot(Value)
        Settings.set("AimbotToggle", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = Settings.get("TeamCheck") == true,
   Flag = "TeamCheck",
   Callback = function(Value)
        aimbotScripts.toggleTeamCheck(Value)
        Settings.set("TeamCheck", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Wall Check",
   CurrentValue = Settings.get("WallCheck") == true,
   Flag = "WallCheck",
   Callback = function(Value)
        aimbotScripts.toggleWallCheck(Value)
        Settings.set("WallCheck", Value)
   end,
})

CombatTab:CreateSlider({
   Name = "Smoothing",
   Range = {1, 10},
   Increment = 1,
   Suffix = "",
   CurrentValue = Settings.get("Smoothing") or 5,
   Flag = "Smoothing",
   Callback = function(Value)
        aimbotScripts.setSmoothing(Value)
        Settings.set("Smoothing", Value)
   end,
})

CombatTab:CreateSlider({
   Name = "Aimbot FOV",
   Range = {10, 500},
   Increment = 10,
   Suffix = "px",
   CurrentValue = Settings.get("FOV") or 200,
   Flag = "FOV",
   Callback = function(Value)
        aimbotScripts.setFOV(Value)
        Settings.set("FOV", Value)
   end,
})

CombatTab:CreateSection("Targeting")

CombatTab:CreateToggle({
   Name = "Target Head",
   CurrentValue = (Settings.get("TargetPart") or "Head") == "Head",
   Flag = "TargetHead",
   Callback = function(Value)
        if Value then
            aimbotScripts.setTargetPart("Head")
            Settings.set("TargetPart", "Head")
        end
   end,
})

CombatTab:CreateToggle({
   Name = "Target UpperTorso",
   CurrentValue = (Settings.get("TargetPart") or "Head") == "UpperTorso",
   Flag = "TargetUpperTorso",
   Callback = function(Value)
        if Value then
            aimbotScripts.setTargetPart("UpperTorso")
            Settings.set("TargetPart", "UpperTorso")
        end
   end,
})

CombatTab:CreateSlider({
   Name = "Max Angle",
   Range = {5, 180},
   Increment = 5,
   Suffix = "deg",
   CurrentValue = Settings.get("MaxAngle") or 180,
   Flag = "MaxAngle",
   Callback = function(Value)
        aimbotScripts.setMaxAngle(Value)
        Settings.set("MaxAngle", Value)
   end,
})

CombatTab:CreateSlider({
   Name = "Max Distance",
   Range = {0, 1000},
   Increment = 50,
   Suffix = "studs",
   CurrentValue = Settings.get("MaxDistance") or 0,
   Flag = "MaxDistance",
   Callback = function(Value)
        aimbotScripts.setMaxDistance(Value)
        Settings.set("MaxDistance", Value)
   end,
})

CombatTab:CreateSection("Aim Assist UI")

CombatTab:CreateToggle({
   Name = "Hold to Aim (RMB)",
   CurrentValue = Settings.get("HoldAim") == true,
   Flag = "HoldAim",
   Callback = function(Value)
        aimbotScripts.toggleHoldToAim(Value)
        Settings.set("HoldAim", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = Settings.get("FOVCircle") == true,
   Flag = "FOVCircle",
   Callback = function(Value)
        aimbotScripts.toggleFOVCircle(Value)
        Settings.set("FOVCircle", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Dynamic Smoothing",
   CurrentValue = Settings.get("DynamicSmoothing") == true,
   Flag = "DynamicSmoothing",
   Callback = function(Value)
        aimbotScripts.toggleDynamicSmoothing(Value)
        Settings.set("DynamicSmoothing", Value)
   end,
})

CombatTab:CreateToggle({
   Name = "Lock Cursor to Target",
   CurrentValue = Settings.get("PointerLock") == true,
   Flag = "PointerLock",
   Callback = function(Value)
        aimbotScripts.togglePointerLock(Value)
        Settings.set("PointerLock", Value)
   end,
})

CombatTab:CreateSection("Key Toggle")

CombatTab:CreateToggle({
   Name = "Enable F Key Toggle",
   CurrentValue = Settings.get("KeyToggle") == true,
   Flag = "KeyToggle",
   Callback = function(Value)
        aimbotScripts.toggleKeyToggle(Value)
        Settings.set("KeyToggle", Value)
   end,
})

do
    local s = Settings.all()
    if s.ESPToggle then visionScripts.toggleESP(true) end
    if s.LabelsToggle then labelsScripts.toggleLabels(true) end
    aimbotScripts.setSmoothing(s.Smoothing)
    aimbotScripts.setFOV(s.FOV)
    aimbotScripts.setTargetPart(s.TargetPart)
    aimbotScripts.setMaxAngle(s.MaxAngle)
    aimbotScripts.setMaxDistance(s.MaxDistance)
    aimbotScripts.toggleTeamCheck(s.TeamCheck)
    aimbotScripts.toggleWallCheck(s.WallCheck)
    aimbotScripts.toggleHoldToAim(s.HoldAim)
    aimbotScripts.toggleFOVCircle(s.FOVCircle)
    aimbotScripts.toggleDynamicSmoothing(s.DynamicSmoothing)
    aimbotScripts.togglePointerLock(s.PointerLock)
    aimbotScripts.toggleKeyToggle(s.KeyToggle)
    aimbotScripts.toggleAimbot(s.AimbotToggle)
end
