local utils = require 'client.utils'
local store = require 'client.module.store'
local currentHouse = store.currentHouse
local housePoints = {}
local target = Framework.target

local function exitHouse()
    local coords = currentHouse.coords
    local isInside = coords and LocalPlayer.state.inHouse

    TriggerServerEvent('bl_houserobbery:server:exitHouse', currentHouse.id)

    store.resetCurrentHouse()
    utils.takeObjectControl:disable(true)

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

local function refreshObjects(objects, skip)
    if not objects then return end

    for i = 1, #objects do
        local object = objects[i]
        local objectId = GetClosestObjectOfType(object.position.x, object.position.y, object.position.z, 3.0, object.model, false, false, false)
        if skip[tostring(i)] and objectId then
            SetEntityAsMissionEntity(objectId, true, true)
            DeleteObject(objectId)
        else
            store.addSprite(objectId or utils.spawnLocalObject(object.model, object.position))
        end
    end
end

local function spawnObjects(interior, blackOut, skip)
    local electricityBox = interior.electricityBox
    if electricityBox then
        require'client.module.interior'.handleBlackOut(electricityBox, blackOut)
    end

    local alarm = interior.alarm
    if alarm then
        local object = utils.spawnLocalObject(alarm.model, alarm.position)
        currentHouse.objects[#currentHouse.objects + 1] = object
        FreezeEntityPosition(object, true)
    end

    refreshObjects(interior.objects, skip)
end

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

function utils.takeObjectControl.onReleased(data)
    if data.clicked then return end
    data.clicked = true

    if not LocalPlayer.state.inHouse then
        data.clicked = false
        return
    end

    local closestSprite = exports.bl_sprites:getClosestSprite(true)
    if not closestSprite then
        data.clicked = false
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
    data.clicked = false
end

RegisterNetEvent('bl_houserobbery:client:syncBlackOut', function(skipObjects)
    store.removeSprites()
    require'client.module.interior'.blackOutInterior()
    refreshObjects(currentHouse.interiorObjects, skipObjects)
    local object = store.findModel(currentHouse.electricityBoxModel)
    if not object then return end

    target.removeLocalEntity(object)
end)

RegisterNetEvent('bl_houserobbery:client:removeObject', function(objectIndex)
    store.removeSprite(nil, objectIndex)
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
    local id, interiorName, blackOut, skipObjects = data.id, data.interiorName, data.blackOut, data.skipObjects

    local isValid = lib.callback.await('bl_houserobbery:client:validPlayer', nil, id)
    assert(isValid, 'Invalid access, how?')

    local interior = interiorName and require 'data.interiors'[interiorName]
    assert(interior, ('couldnt find interior by name %s'):format(interiorName))

    local ped = cache.ped
    local doorCoords = interior.doorCoords

    LocalPlayer.state:set('inHouse', true, true)

    DoScreenFadeOut(250)
    Wait(250)

    SetEntityCoords(ped, doorCoords.x, doorCoords.y, doorCoords.z, false, false, false, false)
    SetEntityHeading(ped, doorCoords.w)

    FreezeEntityPosition(ped, true)
    local interiorId = GetInteriorAtCoords(doorCoords.x, doorCoords.y, doorCoords.z)

    currentHouse.interiorId = interiorId
    currentHouse.interiorObjects = interior.objects
    currentHouse.interiorName = interiorName
    currentHouse.id = id
    currentHouse.coords = data.coords
    currentHouse.ghost = interior.ghost

    lib.waitFor(function()
        if IsInteriorReady(interiorId) then
            return true
        end
    end, 'Interior load timeout', 10000)
    FreezeEntityPosition(ped, false)

    spawnObjects(interior, blackOut, skipObjects)
    registerExit(doorCoords)
    utils.takeObjectControl:disable(false)
    Wait(500)
    DoScreenFadeIn(250)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    exitHouse()
end)