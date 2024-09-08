local currentHouse = {
    exitTarget = nil,
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
        currentHouse = {
            id = id,
            isMlo = house.isMlo,
            coords = house.coords
        }
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

    if currentHouse.exitTarget then
        Framework.target.removeZone(currentHouse.exitTarget)
        currentHouse.exitTarget = nil
    end

    Wait(250)
    DoScreenFadeIn(250)
end

local function registerExit(doorCoords)
    currentHouse.exitTarget = Framework.target.addBoxZone({
        coords = doorCoords.xyz,
        size = vector3(2, 2, 2),
        rotation = 90,
        distance = 5.0,
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

local function blackOutInterior(interiorId)
    local blackOutHash = `BlackOut`
    for i = 1, GetInteriorRoomCount(interiorId) do
        SetInteriorRoomTimecycle(interiorId, i, blackOutHash)
    end

    RefreshInterior(interiorId)
end

RegisterNetEvent('bl_houserobbery:client:enterHouse', function(data)
    local id, interiorName = data.id, data.interiorName
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

    blackOutInterior(interiorId)
    registerExit(doorCoords)
    Wait(500)
    DoScreenFadeIn(250)
end)