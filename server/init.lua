local House = lib.class('House')
local activeHouses = {}

require 'server.modules.housing'
function House:constructor(id, interiorId, coords)
    local private = self.private
    self.id = id
    self.blackOut = false
    private.insidePlayers = {}
    private.interior = interiorId
    self.coords = coords

    activeHouses[id] = self
end

function House:playerEnter(source, initial)
    local id = self.id
    self.private.insidePlayers[source] = true
    SetPlayerRoutingBucket(source, id)
    Player(source).state.instance = id

    TriggerClientEvent("bl_houserobbery:client:enterHouse", source, {
        id = id,
        interiorName = self.private.interior,
        blackOut = self.blackOut
    })

    if initial then
        TriggerClientEvent('bl_houserobbery:client:registerHouse', -1, id)
    end
end

function House:isPlayerInside(source)
    return self.private.insidePlayers[source]
end

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

    local config = require 'data.config'
    local interiorId = houseData.interior or config.defaultInterior
    local house = House:new(id, interiorId, houseData.coords)

    house:playerEnter(src, true)
end, false)