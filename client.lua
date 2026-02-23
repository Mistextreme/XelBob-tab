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
local isTabletOpen  = false
local tabletProp    = nil

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

--- Attach the tablet prop to the player's hand bone
local function createProp(ped)
    local model = GetHashKey(Config.Prop)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end

    tabletProp = CreateModelOnBone(
        ped, model, Config.Bone,
        0.0, 0.0, 0.0,   -- offset
        0.0, 0.0, 0.0,   -- rotation
        true, false, false, false, 2, true
    )

    SetModelAsNoLongerNeeded(model)
end

--- Retrieve weather info and return a table ready to send to the NUI
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
        -- Fallback: read the native weather hash name
        local hash = GetPrevWeatherTypeHashName()
        if hash then
            weatherKey = tostring(hash):upper()
        end
    end

    -- Sanitize: make sure the key actually exists in our tables
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
--  Item (ESX usable item – server triggers this event)
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