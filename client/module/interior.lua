local store = require 'client.module.store'
local currentHouse = store.currentHouse
local utils = require 'client.utils'

local function blackOutInterior()
    local interiorId = currentHouse.interiorId
    if not interiorId then return end

    local blackOutHash = `BlackOut`
    for i = 1, GetInteriorRoomCount(interiorId) do
        SetInteriorRoomTimecycle(interiorId, i, blackOutHash)
    end

    if currentHouse.ghost then
        require'client.module.ghost'(currentHouse.ghost)
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

return {
    blackOutInterior = blackOutInterior,
    handleBlackOut = handleBlackOut,
}