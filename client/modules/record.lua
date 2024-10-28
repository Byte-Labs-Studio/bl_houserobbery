RecordingData = {}
local record = {}
local count = 0

local animations = {}
local npcAnimations = {}
animations[#animations+1] = require 'data.config'.defaultStealingAnimation

for _, v in pairs(require 'data.interiors') do
    local electricityBox = v.electricityBox
    if electricityBox and electricityBox.animation then
        animations[#animations + 1] = electricityBox.animation
    end

    local objects = v.objects
    if objects then
        for _, object in ipairs(v.objects) do
            local anim = object.anim
            if anim then
                animations[#animations + 1] = anim
            end
        end
    end

    local peds = v.peds
    if peds then
        for _, ped in ipairs(v.peds) do
            local anim = ped.anim
            if anim then
                npcAnimations[#npcAnimations + 1] = anim
            end
        end
    end
end

local function getPedCurrentAnim(ped)
    for _,v in ipairs(animations) do
        if IsEntityPlayingAnim(ped, v.dict, v.name, 3) then
            return v
        end
    end
end

RegisterCommand('replay', function()
    local id = require 'client.modules.store'.currentHouse.id
    local houseRecording = lib.callback.await('bl_houserobbery:client:getHouseRecording', nil, id)
    print(json.encode(houseRecording, {indent = true}))

    for entityType, recordData in pairs(houseRecording) do
        CreateThread(function()
            local spwanedPeds = {}
            local ped
            local model = recordData.model or `mp_m_freemode_01`
            local appearance = recordData.appearance
            for k,v in ipairs(recordData.record) do
                local pos = v.position
                local rot = v.rotation
                local weapon = v.weapon
                local dead = v.dead
                if not ped then
                    lib.requestModel(model)
                    ped = CreatePed(2, model, pos.x, pos.y, pos.z, 100.0, false, false)
                    SetModelAsNoLongerNeeded(model)
                    spwanedPeds[#spwanedPeds+1] = ped
                end

                if weapon ~= 0 then
                    GiveWeaponToPed(ped, weapon, 1000, true, true)
                end


                if dead then
                    SetEntityHealth(ped, 0)
                end

                if pos and #(GetEntityCoords(ped) - pos) > 0 then
                    SetEntityCoords(ped, pos.x, pos.y, pos.z-1, false, true, false, false)
                    SetEntityRotation(ped, rot.x, rot.y, rot.z, 2, true)
                end
                Wait(200)
            end
            for k,v in ipairs(spwanedPeds) do
                DeleteEntity(v)
            end
        end)
    end
end, false)

RegisterNetEvent('bl_houserobbery:client:onPlayerEnter', function()
    local ped = cache.ped

    RecordingData.appearance = exports.bl_appearance:GetPlayerPedAppearance()
    RecordingData.record = {}
    while LocalPlayer.state.inHouse do
        Wait(200)
        count += 1
        RecordingData.record[count] = {
            position = GetEntityCoords(ped),
            rotation = GetEntityRotation(ped, 2),
            weapon = cache.weapon,
        }
    end
end)

return record