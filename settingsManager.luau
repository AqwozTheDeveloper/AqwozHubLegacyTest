local HttpService = game:GetService("HttpService")

local module = {}

local CONFIG_FOLDER = "AqwozHubConfig"
local CONFIG_FILE = CONFIG_FOLDER .. "/Settings.json"

local defaults = {
    ESPToggle = false,
    LabelsToggle = false,
    AimbotToggle = false,
    TeamCheck = false,
    WallCheck = false,
    Smoothing = 5,
    FOV = 200,
    TargetPart = "Head",
    MaxAngle = 180,
    MaxDistance = 0,
    HoldAim = false,
    FOVCircle = false,
    DynamicSmoothing = false,
    PointerLock = false,
    KeyToggle = false,
}

local state = nil

local function safeDecode(str)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(str)
    end)
    if ok and type(decoded) == "table" then
        return decoded
    end
    return nil
end

local function ensureFolder()
    if makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local function loadFromDisk()
    if isfile and isfile(CONFIG_FILE) then
        local ok, content = pcall(function()
            return readfile(CONFIG_FILE)
        end)
        if ok and type(content) == "string" then
            local data = safeDecode(content)
            if data then return data end
        end
    end
    return nil
end

local function saveToDisk(tbl)
    if writefile then
        local ok, encoded = pcall(function()
            return HttpService:JSONEncode(tbl)
        end)
        if ok then
            ensureFolder()
            writefile(CONFIG_FILE, encoded)
        end
    end
end

function module.init()
    local loaded = loadFromDisk()
    if loaded then
        state = loaded
        for k, v in pairs(defaults) do
            if state[k] == nil then state[k] = v end
        end
    else
        state = table.clone(defaults)
    end
    saveToDisk(state)
end

function module.get(key)
    if not state then return defaults[key] end
    return state[key]
end

function module.set(key, value)
    if not state then module.init() end
    state[key] = value
    saveToDisk(state)
end

function module.all()
    if not state then module.init() end
    return state
end

return module
