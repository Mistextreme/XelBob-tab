-- ============================================================
--  XelBob-tab | server.lua
--  Authors : Xelyos | Bob's&Co
-- ============================================================

local ESX = nil

-- ----------------------------------------------------------
--  ESX Initialization
--  Everything that calls ESX (RegisterUsableItem AND
--  RegisterServerCallback) is deferred inside this thread
--  so ESX is guaranteed non-nil before any of it runs.
--
--  FIX (pass 1): RegisterUsableItem moved inside thread.
--  FIX (pass 2): RegisterServerCallback was still outside
--                the thread → "attempt to index nil (ESX)"
--                crash on resource start. Moved inside.
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

    -- --------------------------------------------------------
    --  Usable Item Registration
    --  When a player uses the item from inventory the client
    --  event fires to open / close the tablet UI.
    -- --------------------------------------------------------
    if Config.Item then
        ESX.RegisterUsableItem(Config.Item, function(source)
            TriggerClientEvent('xelbob-tab:client:useItem', source)
        end)
    end

    -- --------------------------------------------------------
    --  Job validation callback
    --  Returns the player's current ESX job name to the client,
    --  which can then forward it to the NUI to filter jobSites.
    -- --------------------------------------------------------
    ESX.RegisterServerCallback('xelbob-tab:getJob', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer then
            cb(xPlayer.getJob().name)
        else
            cb('unemployed')
        end
    end)
end)

-- ----------------------------------------------------------
--  NUI close callback relay (optional server-side hook)
--  Fired by the client after the player closes the tablet.
--  Reserved for future server-side logic (logging, durability…)
--  Note: this net event does not require ESX so it is safe
--  to register at module level, outside the init thread.
-- ----------------------------------------------------------

RegisterNetEvent('xelbob-tab:server:close')
AddEventHandler('xelbob-tab:server:close', function()
    -- Reserved for future server-side logic
end)