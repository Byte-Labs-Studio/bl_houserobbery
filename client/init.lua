local utils = require 'client.utils'
local housePoints = {}
local target = Framework.target
local currentHouse = {
    exitTarget = nil,
    objects = {},
    id = 0,
    coords = nil
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
    if not LocalPlayer.state.inHouse then return end
    local coords = currentHouse.coords
    if not coords then return end

    DoScreenFadeOut(250)
    Wait(250)

    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)

    LocalPlayer.state:set('inHouse', false, true)

    local exitTarget = currentHouse.exitTarget
    if exitTarget then
        target.removeZone(exitTarget)
    end

    local electricityTarget = currentHouse.electricityTarget
    if electricityTarget then
        target.removeLocalEntity(electricityTarget)
    end

    for _,entityId in ipairs(currentHouse.objects) do
        DeleteEntity(entityId)
    end

    currentHouse = {
        exitTarget = nil,
        id = 0,
        coords = nil,
        objects = {},
    }

    Wait(250)
    DoScreenFadeIn(250)
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
        currentHouse.electricityTarget = target.addLocalEntity({
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
        FreezeEntityPosition(object, true)
    end

    local objects = interior.objects
    if objects then
        for i = 1, #objects do
            local object = objects[i]
            local objectId = utils.spawnLocalObject(object.model, object.position)
            currentHouse.objects[#currentHouse.objects + 1] = objectId
        end
    end

end

RegisterNetEvent('bl_houserobbery:client:registerHouse', function(houseId)
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