-- ============================================================
--  XelBob-tab | server.lua
--  Authors : Xelyos | Bob's&Co
-- ============================================================

local ESX = nil

-- ----------------------------------------------------------
--  ESX Initialization
--  FIX #5: Wrapping the 'new' ESX init in a thread with a
--  wait-loop prevents a nil crash if es_extended has not
--  finished loading when this resource starts.
--  RegisterUsableItem is deferred until ESX is confirmed ready.
-- ----------------------------------------------------------

Citizen.CreateThread(function()
    if Config.versionESX == 'old' then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Wait(0)
        end
    else
        while ESX == nil do
            local ok, obj = pcall(function()
                return exports['es_extended']:getSharedObject()
            end)
            if ok and obj then
                ESX = obj
            end
            Wait(100)
        end
    end

    -- ----------------------------------------------------------
    --  Usable Item Registration
    --  Moved inside the thread so ESX is guaranteed non-nil.
    --  When a player uses the item from inventory the client
    --  event fires to open / close the tablet UI.
    -- ----------------------------------------------------------

    if Config.Item then
        ESX.RegisterUsableItem(Config.Item, function(source)
            TriggerClientEvent('xelbob-tab:client:useItem', source)
        end)
    end
end)

-- ----------------------------------------------------------
--  NUI close callback relay (optional server-side hook)
--  Fired by the client after the player closes the tablet.
--  Reserved for future server-side logic (logging, durability…)
-- ----------------------------------------------------------

RegisterNetEvent('xelbob-tab:server:close')
AddEventHandler('xelbob-tab:server:close', function()
    -- Reserved for future server-side logic
end)

-- ----------------------------------------------------------
--  Job validation callback
--  Returns the player's current ESX job name to the client,
--  which can then forward it to the NUI to filter jobSites.
-- ----------------------------------------------------------

ESX.RegisterServerCallback('xelbob-tab:getJob', function(source, cb)
    -- ESX may not be ready yet if called extremely early;
    -- guard defensively before using it.
    local xPlayer = ESX and ESX.GetPlayerFromId(source)

    if xPlayer then
        cb(xPlayer.getJob().name)
    else
        cb('unemployed')
    end
end)
