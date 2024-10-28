-- require 'server.modules.record' -- todo after
require 'server.modules.class'
lib.callback.register('bl_houserobbery:server:validPlayer', function(source, id)
    local activeHouse = ActiveHouses[id]
    local isValid = activeHouse and activeHouse:isPlayerInside(source)
    if not isValid then
        lib.print.info(('Player %s tried to enter house with no access, maybe a hacker?'):format(GetPlayerName(source)))
    end
    return isValid
end)


RegisterNetEvent('bl_houserobbery:server:exitHouse', function(houseid, playerRecord)
    local src = source
    local activeHouse = ActiveHouses[houseid]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    -- activeHouse.record = activeHouse.record or {}
    -- activeHouse.record[('player_%s'):format(src)] = playerRecord
    activeHouse:playerExit(src)
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

RegisterCommand('enterhouse', function(src)
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

    local interiorId = houseData.interior or require 'data.config'.defaultInterior
    local house = House:new(id, interiorId, houseData)

    house:playerEnter(src, true)
end, false)