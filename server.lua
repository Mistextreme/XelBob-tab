-- ============================================================
--  XelBob-tab | server.lua
--  Authors : Xelyos | Bob's&Co
-- ============================================================

local ESX = nil

-- ----------------------------------------------------------
--  ESX Initialization
-- ----------------------------------------------------------
if Config.versionESX == 'old' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    ESX = exports['es_extended']:getSharedObject()
end

-- ----------------------------------------------------------
--  Usable Item Registration
--  Registers the tablet as an ESX usable item so that when
--  a player uses it from their inventory the client event
--  is fired to open / close the tablet UI.
-- ----------------------------------------------------------

if Config.Item then
    ESX.RegisterUsableItem(Config.Item, function(source)
        TriggerClientEvent('xelbob-tab:client:useItem', source)
    end)
end

-- ----------------------------------------------------------
--  NUI close callback relay (optional server-side hook)
--  Some ESX builds route NUI callbacks through the server.
--  This event is fired by the client after the player closes
--  the tablet so any server-side cleanup can be done here.
-- ----------------------------------------------------------

RegisterNetEvent('xelbob-tab:server:close')
AddEventHandler('xelbob-tab:server:close', function()
    -- Reserved for future server-side logic (e.g. logging,
    -- removing item durability, etc.)
end)

-- ----------------------------------------------------------
--  Job validation callback
--  The client can call this ESX callback to fetch the
--  current player job, which is then used by the NUI to
--  filter job-restricted applications (see config.js
--  jobSites array).
-- ----------------------------------------------------------

ESX.RegisterServerCallback('xelbob-tab:getJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        cb(xPlayer.getJob().name)
    else
        cb('unemployed')
    end
end)