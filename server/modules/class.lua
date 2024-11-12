House = lib.class('House')
CooldownHouses = {}
ActiveHouses = {}
local housesCameras = {}

local function getPlayerClosestHouse(coords)
    for k,v in pairs(ActiveHouses) do
        if #(v.coords - coords) < 10.0 then
            return v
        end
    end
end

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
            TriggerClientEvent('bl_houserobbery:client:resetHouse', -1, id)
            self:destroy()
        end)
    end

    ActiveHouses[id] = self
end

function House:destroy()
    local id = self.id
    local label = self.label

    for src in pairs(self.private.insidePlayers or {}) do
        TriggerClientEvent('bl_houserobbery:client:exitHouse', src)
    end

    self.blackOut = nil
    self.private = nil
    self.coords = nil
    self.label = nil
    self.cooldown = nil
    self.id = nil

    if self.spawnedPeds then
        for entity in pairs(self.spawnedPeds) do
            DeleteEntity(entity)
        end
    end
    self.spawnedPeds = nil

    CooldownHouses[label] = nil
    ActiveHouses[id] = nil

    collectgarbage("collect")
end

function House:spawnPeds()
    ---@type Peds[] | nil
    local peds = require 'data.interiors'[self.private.interior].peds
    if not peds then return end

    local bl_ecs = exports.bl_ecs
    local id = self.id

    self.spawnedPeds = {}
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
            self.spawnedPeds[ped] = pedData.anim
            SetEntityRoutingBucket(ped, id)
            Entity(ped).state:set('setHate', {
                anim = pedData.anim,
                weapon = pedData.weapon,
            }, true)
        end
    end

    -- self.record = {
    --     peds = {}
    -- }
    -- CreateThread(function()
    --     local recordPeds = self.record.peds
    --     recordPeds.record = {}
    --     while not self:isHouseEmpty() do
    --         Wait(200)
    --         for ped, anim in pairs(self.spawnedPeds) do
    --             if not recordPeds.model then
    --                 recordPeds.model = GetEntityModel(ped)
    --             end
    --             if GetPedSourceOfDeath(ped) == 0 then
    --                 recordPeds.record[#recordPeds.record + 1] = {
    --                     model = GetEntityModel(ped),
    --                     position = GetEntityCoords(ped),
    --                     rotation = GetEntityRotation(ped, 2),
    --                     weapon = GetCurrentPedWeapon(ped),
    --                 }
    --             else
    --                 if not recordPeds.record[#recordPeds.record].dead then
    --                     recordPeds.record[#recordPeds.record + 1] = {
    --                         dead = true,
    --                     }
    --                 end
    --             end
    --         end
    --     end
    -- end)
end

function House:isHouseEmpty()
    return next(self.private.insidePlayers) == nil
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

function House:registerCamera(data)
    self.cameras = self.cameras or {}
    local camera = self.cameras
    camera[#camera + 1] = {
        coords = data.coords,
        rotation = data.rot,
        bucket = self.id
    }
end

RegisterCommand('accessCamera', function(source)
    local closeHouse = getPlayerClosestHouse(GetEntityCoords(GetPlayerPed(source)))
    if not closeHouse or not next(closeHouse.cameras) then return end

    TriggerClientEvent('bl_houserobbery:client:openCamera', source, closeHouse.cameras)
end, false)

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

    local holdingHouseObject = Player(source).state.holdingHouseObject
    if holdingHouseObject then
        SetEntityRoutingBucket(NetworkGetEntityFromNetworkId(holdingHouseObject), private.oldBucket)
    end

    SetPlayerRoutingBucket(source, private.oldBucket)
    Player(source).state.instance = private.oldBucket

    TriggerClientEvent('bl_houserobbery:client:onPlayerExit', source)
end
