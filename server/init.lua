-- require 'server.modules.record' -- todo after
local Framework = Framework
local lib = lib
require 'server.modules.class'
local config = require 'data.config'

---comment
---@param coords vector3
---@return Houses | nil
local function getActiveHouseByCoords(coords)
    for _,v in pairs(ActiveHouses) do
        if #(v.coords - coords) < 10.0 then
            return v
        end
    end
end
exports('getActiveHouseByCoords', getActiveHouseByCoords)

local function getPlayerCurrentHouse(source)
    for _,v in pairs(ActiveHouses) do
        if v and v:isPlayerInside(source) then
            return v
        end
    end
end
exports('getPlayerCurrentHouse', getPlayerCurrentHouse)

local function getPlayersInHouse(id)
    return ActiveHouses[id]:getInsidePlayers()
end

exports('getPlayersInHouse', getPlayersInHouse)


lib.callback.register('bl_houserobbery:server:validPlayer', function(source, id)
    local activeHouse = ActiveHouses[id]
    local isValid = activeHouse and activeHouse:isPlayerInside(source)
    if not isValid then
        lib.print.info(('Player %s tried to enter house with no access, maybe a hacker?'):format(GetPlayerName(source)))
    end
    return isValid
end)

RegisterNetEvent('bl_houserobbery:server:exitHouse', function(houseid)
    local src = source
    local activeHouse = ActiveHouses[houseid]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    -- activeHouse.record = activeHouse.record or {}
    -- activeHouse.record[('player_%s'):format(src)] = playerRecord
    activeHouse:playerExit(src)
end)

RegisterNetEvent('bl_houserobbery:server:registerCamera', function(data)
    local activeHouse = ActiveHouses[data.id]
    if not activeHouse then return end

    activeHouse:registerCamera(data)
end)

RegisterNetEvent('bl_houserobbery:server:takeObject', function(data)
    local src = source
    local activeHouse = ActiveHouses[data.id]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    activeHouse:takeObject(src, data.objectIndex)
end)

RegisterNetEvent('bl_houserobbery:server:enterHouse', function(houseid)
    local src = source
    local activeHouse = ActiveHouses[houseid]
    if not activeHouse then return end

    local coords = GetEntityCoords(GetPlayerPed(src))

    if #(coords - activeHouse.coords) > 3.0 then
        return
    end

    activeHouse:playerEnter(src)
end)

RegisterNetEvent('bl_houserobbery:server:updateHouse', function(data)
    local src = source
    local type, id = data.type, data.id
    local activeHouse = ActiveHouses[id]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    activeHouse[type] = true
    if type == 'blackOut' then
        activeHouse:syncBlackOut()
    end
end)

local function enterClosestHouse(src)
    local id
    repeat
        id = tonumber(lib.string.random('111111', 8))
    until not ActiveHouses[id]

    local houseData = lib.callback.await('bl_houserobbery:client:checkNearbyHouse', src, id)
    if not houseData then return end

    local isHouseExist = CooldownHouses[houseData.label]
    local houseClass = isHouseExist and ActiveHouses[isHouseExist]
    if houseClass then
        houseClass:playerEnter(src)
        return
    end

    local interiorId = houseData.interior or config.defaultInterior
    local house = House:new(id, interiorId, houseData)

    house:playerEnter(src, true)
end
exports('enterClosestHouse', enterClosestHouse)

local core = Framework.core
core.RegisterUsableItem(config.lockPickItem, function(source)
    enterClosestHouse(source)
end)

local breachingData = config.cameraBreaching
core.RegisterUsableItem(breachingData.item, function(source)
    local player = core.GetPlayer(source)
    local job = player?.job
    if not job then return error(('Player %s has no job'):format(source)) end
    if not breachingData.groups[player.job.name] or breachingData.groups[player.job.name] > job.grade.name then return end

    local closeHouse = getActiveHouseByCoords(GetEntityCoords(GetPlayerPed(source)))
    if not closeHouse or not next(closeHouse.cameras) then return end

    TriggerClientEvent('bl_houserobbery:client:openCamera', source, closeHouse.cameras)
end)