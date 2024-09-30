House = lib.class('House')
CooldownHouses = {}
ActiveHouses = {}

function House:constructor(id, interiorId, houseData)
    local private = self.private
    self.id = id
    self.blackOut = false
    private.insidePlayers = {}
    private.interior = interiorId
    private.skipObjects = {}
    self.coords = houseData.coords
    self.label = houseData.label
    self.cooldown = true

    CooldownHouses[self.label] = id
    TriggerClientEvent('bl_houserobbery:client:registerHouse', -1, {
        id = id,
        coords = self.coords
    })

    local resetCooldown = require 'data.config'.resetCooldown
    if resetCooldown > 0 then
        SetTimeout(resetCooldown, function()
            self.cooldown = false
            CooldownHouses[self.label] = nil
            TriggerClientEvent('bl_houserobbery:client:resetHouse', -1, id)
        end)
    end

    ActiveHouses[id] = self
end

function House:spawnPeds()
    ---@type Peds[]
    local peds = require 'data.interiors'[self.private.interior].peds
    if not peds then return end

    local bl_ecs = exports.bl_ecs
    local id = self.id

    for i = 1, #peds do
        local pedData = peds[i]
        local chance = pedData.chance
        if chance > 0 and math.random(100) <= chance then
            local coords = pedData.coords
            local model = pedData.model
            local ped = bl_ecs:spawnPed({
                model = model,
                coords = coords,
            })
            SetEntityRoutingBucket(ped, id)
            Entity(ped).state:set('setHate', true, true)
            CreateThread(function()
                local anim = pedData.anim
                while GetPedSpecificTaskType(ped, 0) == 0 or GetPedSpecificTaskType(ped, 0) == 531 do
                    TaskPlayAnim(ped, anim.dict, anim.name, 1.0, 1.0, -1, 2, 0.0, false, false, false)
                    Wait(100)
                end
                GiveWeaponToPed(ped, pedData.weapon, 100, true, false)
            end)
        end
    end
end

function House:onPlayerSpawn(source, init)
    if init then
        self:spawnPeds()
    end

    TriggerClientEvent('bl_houserobbery:client:onPlayerEnter', source)
end

function House:playerEnter(source, init)
    local id = self.id
    local private = self.private
    private.insidePlayers[source] = true
    private.oldBucket = GetPlayerRoutingBucket(source)
    SetPlayerRoutingBucket(source, id)
    Player(source).state.instance = id

    lib.callback('bl_houserobbery:client:enterHouse', source, function(success)
        if not success then return end
        self:onPlayerSpawn(source, init)
    end, {
        id = id,
        interiorName = private.interior,
        blackOut = self.blackOut,
        coords = self.coords,
        skipObjects = private.skipObjects
    })
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

    private.skipObjects[tostring(objectIndex)] = true
    player.addItem(object.item, 1)

    for src in pairs(private.insidePlayers) do
        TriggerClientEvent('bl_houserobbery:client:removeObject', src, objectIndex)
    end
end

function House:syncBlackOut()
    local private = self.private

    for src in pairs(private.insidePlayers) do
        TriggerClientEvent('bl_houserobbery:client:syncBlackOut', src, private.skipObjects)
    end
end

function House:playerExit(source)
    local private = self.private
    if not private.insidePlayers[source] then return end
    private.insidePlayers[source] = nil
    SetPlayerRoutingBucket(source, private.oldBucket)
    Player(source).state.instance = private.oldBucket
end