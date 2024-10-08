local store = require 'client.module.store'
local utils = require 'client.utils'
local currentHouse = store.currentHouse

local function blackOutInterior()
    local interiorId = currentHouse.interiorId
    if not interiorId then return end

    local blackOutHash = `NG_filmic04`
    for i = 1, GetInteriorRoomCount(interiorId) do
        SetInteriorRoomTimecycle(interiorId, i, blackOutHash)
    end

    local ghost = currentHouse.ghost
    if ghost then
        require'client.module.ghost'(ghost)
    end

    RefreshInterior(interiorId)
    lib.waitFor(function()
        if IsInteriorReady(interiorId) then
            return true
        end
    end, 'Interior load timeout', 10000)
end

local function handleBlackOut(electricityBox, blackOut)
    currentHouse.electricityBoxModel = electricityBox.model
    local object = utils.spawnLocalObject(electricityBox.model, electricityBox.position)
    currentHouse.objects[#currentHouse.objects + 1] = object
    FreezeEntityPosition(object, true)

    if blackOut then
        blackOutInterior()
    else
        Framework.target.addLocalEntity({
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

---@param objects Objects[]
---@param skip table<string, boolean>
local function refreshObjects(objects, skip)
    if not objects then return end

    local function deleteObj(entity)
        SetEntityAsMissionEntity(entity, true, true)
        DeleteObject(entity)
    end

    for i = 1, #objects do
        local object = objects[i]
        local position = object.position
        local objectId = GetClosestObjectOfType(position.x, position.y, position.z, 3.0, object.defaultModel or object.model, false, false, false)
        if skip[tostring(i)] and objectId then
            deleteObj(objectId)
        else
            if DoesEntityExist(objectId) and GetEntityModel(objectId) == object.defaultModel then
                deleteObj(objectId)

                ---@diagnostic disable-next-line: cast-local-type
                objectId = nil
            end

            store.addSprite(objectId or utils.spawnLocalObject(object.model, position))
        end
    end
end


---@param blackOut boolean
---@param skip table<string, boolean>
local function spawnObjects(interiorData, blackOut, skip)
    local electricityBox = interiorData.electricityBox
    if electricityBox then
        handleBlackOut(electricityBox, blackOut)
    end

    local alarm = interiorData.alarm
    if alarm then
        local object = utils.spawnLocalObject(alarm.model, alarm.position)
        currentHouse.objects[#currentHouse.objects + 1] = object
        FreezeEntityPosition(object, true)
    end

    refreshObjects(interiorData.objects, skip)
end

return {
    blackOutInterior = blackOutInterior,
    handleBlackOut = handleBlackOut,
    refreshObjects = refreshObjects,
    spawnObjects = spawnObjects,
}