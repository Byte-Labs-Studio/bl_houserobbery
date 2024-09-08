local House = lib.class('House')
local activeHouses = {}

function House:constructor(id, interiorId)
    local private = self.private
    self.id = id
    private.insidePlayers = {}
    private.interior = interiorId

    activeHouses[id] = self
end

function House:playerEnter(source)
    local id = self.id
    self.private.insidePlayers[source] = true
    SetPlayerRoutingBucket(source, id)
    Player(source).state.instance = id

    TriggerClientEvent("bl_houserobbery:client:enterHouse", source, {
        id = id,
        interiorName = self.private.interior
    })
end

RegisterCommand('enterhouse', function(src)
    local id
    repeat
        id = tonumber(lib.string.random('111111', 8))
    until not activeHouses[id]

    local houseData = lib.callback.await('bl_houserobbery:client:checkNearbyHouse', src, id)
    if not houseData then return end

    local config = require 'data.config'
    local interiorId = houseData.interior or config.defaultInterior
    local house = House:new(id, interiorId)

    house:playerEnter(src)
end, false)