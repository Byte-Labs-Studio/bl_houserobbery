local utils = require 'client.utils'
local config = require 'data.config'
local housePoints = {}
local target = Framework.target
local currentHouse = {
    exitTarget = nil,
    id = 0,
    coords = nil,
    objects = {},
    targets = {},
    sprites = {},
}

lib.callback.register('bl_houserobbery:client:checkNearbyHouse', function(id)
    local coords = GetEntityCoords(cache.ped)
    local houses = require 'data.houses'
    local house
    for i = 1, #houses do
        local houseCoords = houses[i].coords
        if #(coords - houseCoords) < 3 then
            house = houses[i]
            break
        end
    end

    return house
end)

local function exitHouse()
    local coords = currentHouse.coords
    local isInside = coords and LocalPlayer.state.inHouse
    local exitTarget = currentHouse.exitTarget
    if exitTarget then
        target.removeZone(exitTarget)
    end

    for _, entityId in ipairs(currentHouse.objects) do
        target.removeLocalEntity(entityId)
        DeleteEntity(entityId)
    end

    for _, sprite in ipairs(currentHouse.sprites) do
        DeleteEntity(sprite.entity)
        sprite:removeSprite()
    end

    TriggerServerEvent('bl_houserobbery:server:exitHouse', currentHouse.id)

    currentHouse = {
        exitTarget = nil,
        id = 0,
        coords = nil,
        objects = {},
        targets = {},
        sprites = {},
    }

    if isInside then
        DoScreenFadeOut(250)
        Wait(250)

        SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

        LocalPlayer.state:set('inHouse', false, true)

        Wait(250)
        DoScreenFadeIn(250)
    end
end

local function registerExit(doorCoords)
    currentHouse.exitTarget = target.addBoxZone({
        coords = doorCoords.xyz,
        size = vector3(2, 2, 2),
        rotation = 90,
        distance = 2.0,
        debug = true,
        options = {
            {
                label = "Exit",
                icon = "fa-solid fa-door-open",
                onSelect = exitHouse
            },
        }
    })
end

local function blackOutInterior()
    local interiorId = currentHouse.interiorId
    if not interiorId then return end

    local blackOutHash = `BlackOut`
    for i = 1, GetInteriorRoomCount(interiorId) do
        SetInteriorRoomTimecycle(interiorId, i, blackOutHash)
    end

    RefreshInterior(interiorId)
end

local function findModel(model)
    for k,v in ipairs(currentHouse.objects) do
        if GetEntityModel(v) == model then
            return v
        end
    end
end

RegisterNetEvent('bl_houserobbery:client:syncBlackOut', function()
    blackOutInterior()

    local object = findModel(currentHouse.electricityBoxModel)
    if not object then return end

    target.removeLocalEntity(object)
end)

local function handleBlackOut(electricityBox, blackOut)
    currentHouse.electricityBoxModel = electricityBox.model
    local object = utils.spawnLocalObject(electricityBox.model, electricityBox.position)
    currentHouse.objects[#currentHouse.objects + 1] = object
    FreezeEntityPosition(object, true)

    if blackOut then
        blackOutInterior()
    else
        target.addLocalEntity({
            entity = object,
            options = {
                {
                    label = "Destroy",
                    icon = "fa-solid fa-circle-xmark",
                    distance = 1.0,
                    onSelect = function()
                        local ped = cache.ped
                        TaskTurnPedToFaceEntity(ped, object, -1)
                        Wait(1000)
                        TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_HAMMERING', 0, true)
                        Wait(2000)
                        ClearPedTasks(ped)
                        TriggerServerEvent('bl_houserobbery:server:updateHouse', {
                            type = 'blackOut',
                            id = currentHouse.id
                        })
                    end
                },
            }
        })
    end
end

local function spawnObjects(interior, blackOut)
    local electricityBox = interior.electricityBox
    if electricityBox then
        handleBlackOut(electricityBox, blackOut)
    end

    local alarm = interior.alarm
    if alarm then
        local object = utils.spawnLocalObject(alarm.model, alarm.position)
        currentHouse.objects[#currentHouse.objects + 1] = object
        FreezeEntityPosition(object, true)
    end

    local bl_sprites = exports.bl_sprites
    local objects = interior.objects
    if objects then
        for i = 1, #objects do
            local object = objects[i]
            local objectId = GetClosestObjectOfType(object.position.x, object.position.y, object.position.z, 3.0, object.model, false, false, false) or utils.spawnLocalObject(object.model, object.position)
            currentHouse.sprites[i] = bl_sprites:spriteOnEntity({
                entity = objectId,
                data = i,
                distance = 1.5,
                shape = 'circle',
                scale = 0.025,
                key = 'E',
            })
        end
    end
end

function utils.takeObjectControl:onReleased()
    if not LocalPlayer.state.inHouse then return end

    local closestSprite = exports.bl_sprites:getClosestSprite(true)
    if not closestSprite  then
        return
    end
    local objectIndex = closestSprite.data

    local anim = require 'data.interiors'[currentHouse.interiorName].objects[objectIndex].anim or {
        dict = 'missmechanic',
        name = 'work2_base'
    }

    if anim then
        utils.playAnim({
            dict = anim.dict,
            name = anim.name,
            duration = 5000
        })
    end

    TriggerServerEvent('bl_houserobbery:server:takeObject', {
        objectIndex = objectIndex,
        id = currentHouse.id
    })
end

RegisterNetEvent('bl_houserobbery:client:removeObject', function(objectIndex)
    local sprite = currentHouse.sprites[objectIndex]
    if not sprite then return end

    SetEntityAsMissionEntity(sprite.entity, true, true)
    DeleteObject(sprite.entity)
    sprite:removeSprite()
    currentHouse.sprites[objectIndex] = nil
end)

RegisterNetEvent('bl_houserobbery:client:resetHouse', function(id)
    housePoints[id]:removeSprite()
    housePoints[id] = nil
end)

RegisterNetEvent('bl_houserobbery:client:registerHouse', function(data)
    local houseId = data.id
    housePoints[houseId] = exports.bl_sprites:sprite({
        coords = data.coords,
        distance = 3.0,
        shape = 'circle',
        scale = 0.03,
        key = 'E',
        onEnter = function()
            currentHouse.id = houseId
            currentHouse.coords = data.coords
        end,
        nearby = function()
            if not IsControlJustReleased(2, 38) then return end

            TriggerServerEvent('bl_houserobbery:server:enterHouse', houseId)
        end,
    })
end)

RegisterNetEvent('bl_houserobbery:client:enterHouse', function(data)
    local id, interiorName, blackOut = data.id, data.interiorName, data.blackOut

    local isValid = lib.callback.await('bl_houserobbery:client:validPlayer', nil, id)
    if not isValid then return end

    local interior = interiorName and require 'data.interiors'[interiorName]
    if not interior then return end

    local ped = cache.ped
    local doorCoords = interior.doorCoords

    currentHouse.interiorName = interiorName
    currentHouse.id = id
    currentHouse.coords = data.coords

    LocalPlayer.state:set('inHouse', true, true)

    DoScreenFadeOut(250)
    Wait(250)

    SetEntityCoords(ped, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false, false)
    SetEntityHeading(ped, doorCoords.w)

    FreezeEntityPosition(ped, true)
    local interiorId = GetInteriorAtCoords(doorCoords.x, doorCoords.y, doorCoords.z)
    currentHouse.interiorId = interiorId
    
    lib.waitFor(function()
        if IsInteriorReady(interiorId) then
            return true
        end
    end, 'Interior load timeout', 10000)
    FreezeEntityPosition(ped, false)

    spawnObjects(interior, blackOut)
    registerExit(doorCoords)
    Wait(500)
    DoScreenFadeIn(250)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    exitHouse()
end)