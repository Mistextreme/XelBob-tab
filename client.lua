-- ============================================================
--  XelBob-tab | client.lua
--  Authors : Xelyos | Bob's&Co
-- ============================================================

local ESX = nil

-- ----------------------------------------------------------
--  ESX Initialization
-- ----------------------------------------------------------
if Config.versionESX == 'old' then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
else
    Citizen.CreateThread(function()
        while ESX == nil do
            ESX = exports['es_extended']:getSharedObject()
            Citizen.Wait(0)
        end
    end)
end

-- ----------------------------------------------------------
--  State
-- ----------------------------------------------------------
local isTabletOpen = false
local tabletProp   = nil

-- ----------------------------------------------------------
--  Weather hash -> name reverse lookup table
--  FIX #4: GetPrevWeatherTypeHashName() returns a joaat hash
--  (number), NOT a string — a reverse-lookup table is required.
-- ----------------------------------------------------------
local weatherHashMap = {}
local weatherNames = {
    'CLOUDS', 'RAIN', 'CLEAR', 'OVERCAST', 'EXTRASUNNY',
    'CLEARING', 'NEUTRAL', 'THUNDER', 'SMOG', 'FOGGY',
    'SNOWLIGHT', 'SNOW', 'BLIZZARD', 'XMAS', 'HALLOWEEN',
}
for _, name in ipairs(weatherNames) do
    weatherHashMap[GetHashKey(name)] = name
end

-- ----------------------------------------------------------
--  Helpers
-- ----------------------------------------------------------

--- Delete the held prop if it still exists
local function deleteProp()
    if tabletProp and DoesEntityExist(tabletProp) then
        DeleteObject(tabletProp)
    end
    tabletProp = nil
end

--- Attach the tablet prop to the player's hand bone.
--- FIX #1: CreateModelOnBone does not exist in FiveM/GTA5.
---         Correct approach: CreateObject + AttachEntityToEntity.
local function createProp(ped)
    local model = GetHashKey(Config.Prop)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    tabletProp = CreateObject(model, 0.0, 0.0, 0.0, true, true, false)

    AttachEntityToEntity(
        tabletProp, ped,
        GetPedBoneIndex(ped, Config.Bone),
        0.0, 0.0, 0.0,   -- position offset
        0.0, 0.0, 0.0,   -- rotation offset
        true, true, false, true, 1, true
    )

    SetModelAsNoLongerNeeded(model)
end

--- Build the NUI payload with current weather data.
local function buildWeatherPayload()
    local weatherKey = 'CLEAR'

    if Config.easytime then
        -- cd_easytime exposes the current weather type as a string
        local ok, result = pcall(function()
            return exports['cd_easytime']:getWeather()
        end)
        if ok and result then
            weatherKey = tostring(result):upper()
        end
    else
        -- FIX #4: GetPrevWeatherTypeHashName() returns a hash number.
        -- Use the reverse-lookup table to convert to a name string.
        local hash = GetPrevWeatherTypeHashName()
        if hash and weatherHashMap[hash] then
            weatherKey = weatherHashMap[hash]
        end
    end

    -- Sanitize: ensure the key exists in our config tables
    if not Config.weatherIcons[weatherKey] then
        weatherKey = 'CLEAR'
    end

    local locale     = Locales[Config.Locale] or Locales['en'] or {}
    local condition  = locale[weatherKey] or weatherKey
    local icon       = Config.weatherIcons[weatherKey]
    local background = Config.weatherGif[weatherKey] or ''

    -- cd_easytime temperature (optional – exposed as getTemperature on some builds)
    local temp = '22'
    if Config.easytime then
        local ok2, t = pcall(function()
            return exports['cd_easytime']:getTemperature()
        end)
        if ok2 and t then
            temp = tostring(math.floor(tonumber(t) or 22))
        end
    end

    return {
        action     = 'open',
        weather    = condition,
        icon       = icon,
        temp       = temp,
        background = background,
        truefalse  = Config.easytime and 'weather-widget' or 'weather-widgetb'
    }
end

-- ----------------------------------------------------------
--  Open / Close
-- ----------------------------------------------------------

local function openTablet()
    if isTabletOpen then return end
    isTabletOpen = true

    local ped = PlayerPedId()

    -- Animation
    RequestAnimDict(Config.AnimDict)
    while not HasAnimDictLoaded(Config.AnimDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped, Config.AnimDict, 'base', 3.0, -3.0, -1, 49, 0, false, false, false)

    -- Prop
    createProp(ped)

    -- NUI
    SetNuiFocus(true, true)
    SendNUIMessage(buildWeatherPayload())
end

local function closeTablet()
    if not isTabletOpen then return end
    isTabletOpen = false

    local ped = PlayerPedId()

    -- Stop animation
    StopAnimTask(ped, Config.AnimDict, 'base', 3.0)

    -- Remove prop
    deleteProp()

    -- NUI
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- ----------------------------------------------------------
--  NUI Callbacks
-- ----------------------------------------------------------

-- Called when the player presses Escape inside the NUI
RegisterNUICallback('close', function(_, cb)
    closeTablet()
    cb('ok')
end)

-- ----------------------------------------------------------
--  Command
-- ----------------------------------------------------------

if Config.Command then
    RegisterCommand(Config.Command, function()
        if isTabletOpen then
            closeTablet()
        else
            openTablet()
        end
    end, false)

    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, Config.CommandDescription)
end

-- ----------------------------------------------------------
--  Item (ESX usable item - server triggers this event)
-- ----------------------------------------------------------

if Config.Item then
    RegisterNetEvent('xelbob-tab:client:useItem')
    AddEventHandler('xelbob-tab:client:useItem', function()
        if isTabletOpen then
            closeTablet()
        else
            openTablet()
        end
    end)
end

-- ----------------------------------------------------------
--  Cleanup on resource stop
-- ----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if isTabletOpen then
        closeTablet()
    end
end)
