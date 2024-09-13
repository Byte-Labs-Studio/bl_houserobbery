local House = lib.class('House')
local activeHouses = {}
local cooldownHouses = {}
local config = require 'data.config'

require 'server.modules.housing'

function House:constructor(id, interiorId, houseData)
    local private = self.private
    self.id = id
    self.blackOut = false
    private.insidePlayers = {}
    private.interior = interiorId
    self.coords = houseData.coords
    self.label = houseData.label

    activeHouses[id] = self
end

function House:playerEnter(source, initial)
    local id = self.id
    local private = self.private
    private.insidePlayers[source] = true
    SetPlayerRoutingBucket(source, id)
    Player(source).state.instance = id

    TriggerClientEvent("bl_houserobbery:client:enterHouse", source, {
        id = id,
        interiorName = private.interior,
        blackOut = self.blackOut,
        coords = self.coords
    })

    if initial then
        self.cooldown = true
        cooldownHouses[self.label] = id
        TriggerClientEvent('bl_houserobbery:client:registerHouse', -1, {
            id = id,
            coords = self.coords
        })

        if config.resetCooldown > 0 then
            SetTimeout(config.resetCooldown, function()
                self.cooldown = false
                cooldownHouses[self.label] = nil
                TriggerClientEvent('bl_houserobbery:client:resetHouse', -1, id)
            end)
        end
    end
end

function House:isPlayerInside(source)
    return self.private.insidePlayers[source]
end

function House:takeObject(source, objectIndex)
    local private = self.private
    local object = require 'data.interiors'[private.interior].objects[objectIndex]
    if not object then return end

    local player = Framework.core.GetPlayer(source)
    if not player then return end

    player.addItem(object.item, 1)

    for src in pairs(private.insidePlayers) do
        TriggerClientEvent('bl_houserobbery:client:removeObject', src, objectIndex)
    end
end

function House:playerExit(source)
    local private = self.private
    if not private.insidePlayers[source] then return end
    private.insidePlayers[source] = nil
    SetPlayerRoutingBucket(source, 1)
    Player(source).state.instance = 1
end

lib.callback.register('bl_houserobbery:client:validPlayer', function(source, id)
    local activeHouse = activeHouses[id]
    return activeHouse and activeHouse:isPlayerInside(source)
end)

RegisterNetEvent('bl_houserobbery:server:exitHouse', function(houseid)
    local src = source
    local activeHouse = activeHouses[houseid]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    activeHouse:playerExit(src)
end)

RegisterNetEvent('bl_houserobbery:server:takeObject', function(data)
    local src = source
    local activeHouse = activeHouses[data.id]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    activeHouse:takeObject(src, data.objectIndex)
end)

RegisterNetEvent('bl_houserobbery:server:enterHouse', function(houseid)
    local src = source
    local activeHouse = activeHouses[houseid]
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
    local activeHouse = activeHouses[id]
    if not activeHouse or not activeHouse:isPlayerInside(src) then return end

    activeHouse[type] = true
end)

RegisterCommand('enterhouse', function(src)
    local id
    repeat
        id = tonumber(lib.string.random('111111', 8))
    until not activeHouses[id]

    local houseData = lib.callback.await('bl_houserobbery:client:checkNearbyHouse', src, id)
    if not houseData then return end

    local isHouseExist = cooldownHouses[houseData.label]
    local houseClass = isHouseExist and activeHouses[isHouseExist]
    if houseClass then
        houseClass:playerEnter(src)
        return
    end

    local interiorId = houseData.interior or config.defaultInterior
    local house = House:new(id, interiorId, houseData)

    house:playerEnter(src, true)
end, false)