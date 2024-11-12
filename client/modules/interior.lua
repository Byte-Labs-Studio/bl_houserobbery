local store = require 'client.modules.store'
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
        require'client.modules.ghost'(ghost)
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

            if object.camera then
                TriggerServerEvent('bl_houserobbery:server:registerCamera', {
                    id = currentHouse.id,
                    coords = position,
                    rot = object.rotation
                })
            end
            store.addSprite(i, objectId ~= 0 and objectId or utils.spawnLocalObject(object.model, position, object.freeze))
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

        -- local handlee
        -- if not IsNamedRendertargetRegistered('npcphone') then
        --     RegisterNamedRendertarget('npcphone', false)
        --     if not IsNamedRendertargetLinked(alarm.model) then
        --         LinkNamedRendertarget(alarm.model)
        --     end
        --     handlee = GetNamedRendertargetRenderId('npcphone')
        -- end

        -- local txd = CreateRuntimeTxd('prop_phone_proto')
        -- local dui = CreateDui('https://www.google.com', 1448, 724)
        -- local handle = GetDuiHandle(dui)
        -- CreateRuntimeTextureFromDuiHandle(txd, "dui", handle)
        -- CreateThread(function()
        --     while true do
        --         Wait(0)
        --         SetTextRenderId(handlee) -- set render ID to the render target
        --         SetScriptGfxDrawOrder(4)
        --         SetScriptGfxDrawBehindPausemenu(true) -- allow it to draw behind pause menu
        --         DrawSprite(alarm.model, "dui", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 1.0) -- draw Dui Sprite
        --         SetTextRenderId(1) -- Reset Render ID (1 is default)
        --     end
        -- end)
    end

    refreshObjects(interiorData.objects, skip)
end

return {
    blackOutInterior = blackOutInterior,
    handleBlackOut = handleBlackOut,
    refreshObjects = refreshObjects,
    spawnObjects = spawnObjects,
}