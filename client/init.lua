local cache = cache
local Framework = Framework
local lib = lib
local utils = require 'client.utils'
local store = require 'client.modules.store'
-- require 'client.modules.record'
local currentHouse = store.currentHouse
local housePoints = {}
ClearFocus()

local function exitHouse(restart)
    local coords = currentHouse.coords
    if not coords then return end
    TriggerServerEvent('bl_houserobbery:server:exitHouse', currentHouse.id)
    store.resetCurrentHouse()
    utils.takeObjectControl:disable(true)

    if coords and LocalPlayer.state.inHouse then
        if not restart then
            DoScreenFadeOut(250)
            Wait(250)
        end

        SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

        LocalPlayer.state:set('inHouse', false, true)

        if not restart then
            Wait(250)
            DoScreenFadeIn(250)
        end
    end
end
RegisterNetEvent('bl_houserobbery:client:exitHouse', exitHouse)

---@param doorCoords vector3
local function registerExit(doorCoords)
    currentHouse.exitTarget = Framework.target.addBoxZone({
        coords = doorCoords.xyz,
        size = vector3(2, 2, 2),
        rotation = 90,
        distance = 2.0,
        debug = require 'data.config'.debug,
        options = {
            {
                label = "Exit",
                icon = "fa-solid fa-door-open",
                onSelect = exitHouse
            },
        }
    })
end

---Houses
---@return ConfigHouses
lib.callback.register('bl_houserobbery:client:checkNearbyHouse', function()
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
    if LocalPlayer.state.holdingHouseObject then
        Framework.notify({
            title = 'You already holding a prop',
            type = 'error'
        })
        return
    end

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
    local object = require 'data.interiors'[currentHouse.interiorName].objects[objectIndex]

    local anim = object and object.anim or {
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
    if object.carry then
        Wait(200)
        utils.carryObject({
            model = object.model,
            itemName = object.item
        })
    end
    data.clicked = false
end

---@param skipObjects SkipObjects
RegisterNetEvent('bl_houserobbery:client:syncBlackOut', function(skipObjects)
    store.removeSprites()
    local interior = require'client.modules.interior'

    interior.blackOutInterior()
    interior.refreshObjects(currentHouse.interiorObjects, skipObjects)

    local object = store.findModel(currentHouse.electricityBoxModel)
    if not object then return end

    Framework.target.removeLocalEntity({
        entity = object
    })
end)

---@param objectIndex number
RegisterNetEvent('bl_houserobbery:client:removeObject', function(objectIndex)
    store.removeSprite(nil, objectIndex)
end)

---@param id Id
RegisterNetEvent('bl_houserobbery:client:resetHouse', function(id)
    housePoints[id]:removeSprite()
    housePoints[id] = nil
end)

---@param data RegisterHouse
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

---@param data EnterHouse
lib.callback.register('bl_houserobbery:client:enterHouse', function(data)
    local id, interiorName, blackOut, skipObjects = data.id, data.interiorName, data.blackOut, data.skipObjects

    local isValid = lib.callback.await('bl_houserobbery:server:validPlayer', nil, id)
    assert(isValid, 'Invalid access, how?')

    local interior = interiorName and require 'data.interiors'[interiorName]
    assert(interior, ('couldnt find interior by name %s'):format(interiorName))

    local ped = cache.ped
    local doorCoords = interior.doorCoords

    LocalPlayer.state:set('inHouse', true, true)

    DoScreenFadeOut(250)
    Wait(250)

    local success, result = pcall(function()
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

        require 'client.modules.peds' -- load ped module
        FreezeEntityPosition(ped, false)
        require 'client.modules.interior'.spawnObjects(interior, blackOut, skipObjects)
        -- require 'client.modules.peds'.create(interior.peds)
        registerExit(doorCoords)
        utils.takeObjectControl:disable(false)
        Wait(500)
    end)
    if not success then
        Framework.notify({
            title = 'There was error while entering the house, check f8',
            type = 'error'
        })
        lib.print.error(result)
        exitHouse()
    end
    DoScreenFadeIn(250)
    return success
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    exitHouse(true)
end)