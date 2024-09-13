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

    if house then
        currentHouse.id = id
        currentHouse.isMlo = house.isMlo
        currentHouse.coords = house.coords
    end

    return house
end)

local function exitHouse()
    local coords = currentHouse.coords
    local isInside = coords and LocalPlayer.state.inHouse
    if isInside then
        DoScreenFadeOut(250)
        Wait(250)

        SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

        LocalPlayer.state:set('inHouse', false, true)
    end

    local exitTarget = currentHouse.exitTarget
    if exitTarget then
        target.removeZone(exitTarget)
    end

    for _, entityId in ipairs(currentHouse.objects) do
        DeleteEntity(entityId)
    end

    for _, sprite in ipairs(currentHouse.sprites) do
        DeleteEntity(sprite.entity)
        sprite:removeSprite()
    end

    for _, targetData in ipairs(currentHouse.targets) do
        target.removeLocalEntity(targetData)
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
    local blackOutHash = `BlackOut`
    for i = 1, GetInteriorRoomCount(interiorId) do
        SetInteriorRoomTimecycle(interiorId, i, blackOutHash)
    end

    RefreshInterior(interiorId)
end

local function handleBlackOut(electricityBox, blackOut)
    local object = utils.spawnLocalObject(electricityBox.model, electricityBox.position)
    currentHouse.objects[#currentHouse.objects + 1] = object
    FreezeEntityPosition(object, true)

    if blackOut then
        blackOutInterior()
    else
        currentHouse.targets[#currentHouse.targets + 1] = target.addLocalEntity({
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
                        blackOutInterior()
                        target.removeLocalEntity(object)
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

    local anim = require 'data.interiors'[currentHouse.interiorName].objects[objectIndex].anim

    if anim then
        utils.playAnim({
            dict = object.dict,
            name = object.name,
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

RegisterNetEvent('bl_houserobbery:client:registerHouse', function(houseId)
RegisterNetEvent('bl_houserobbery:client:resetHouse', function(id)
    housePoints[id]:removeSprite()
    housePoints[id] = nil
end)
    housePoints[houseId] = exports.bl_sprites:sprite({
        coords = currentHouse.coords,
        distance = 3.0,
        shape = 'circle',
        scale = 0.03,
        key = 'E',
        nearby = function()
            if not IsControlJustReleased(2, 38) then return end

            TriggerServerEvent('bl_houserobbery:server:enterHouse', houseId)
        end,
    })
end)

RegisterNetEvent('bl_houserobbery:client:enterHouse', function(data)
    local id, interiorName, blackOut = data.id, data.interiorName, data.blackOut
    if currentHouse.id ~= id then return end

    local interior = interiorName and require 'data.interiors'[interiorName]
    if not interior then return end

    local ped = cache.ped
    local doorCoords = interior.doorCoords

    DoScreenFadeOut(250)
    Wait(250)

    LocalPlayer.state:set('inHouse', true, true)
    SetEntityCoords(ped, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false, false)
    SetEntityHeading(ped, doorCoords.w)

    FreezeEntityPosition(ped, true)
    local interiorId = GetInteriorAtCoords(doorCoords.x, doorCoords.y, doorCoords.z)
    currentHouse.interiorId = interiorId
    currentHouse.interiorName = interiorName
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