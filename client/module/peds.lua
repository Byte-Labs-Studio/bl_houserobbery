local group = 'HOUSEOWNER'
local groupHash = joaat(group)
AddRelationshipGroup(group)

AddStateBagChangeHandler("setHate", nil, function(bagName, key, anim)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end

    while not HasCollisionLoadedAroundEntity(entity) or not DoesEntityExist(entity) do
        Wait(250)
    end

    -- lib.requestAnimDict(anim.dict)
    -- TaskPlayAnim(entity, anim.dict, anim.name, 1.0, 1.0, -1, 2, 0.0, false, false, false)
    -- RemoveAnimDict(anim.dict)

    SetPedRandomProps(entity)
    SetPedRelationshipGroupHash(entity, groupHash)
    SetRelationshipBetweenGroups(5, `PLAYER`, groupHash)
    SetRelationshipBetweenGroups(5, groupHash, `PLAYER`)
    SetPedCombatAttributes(entity, 3, true)
    SetPedCombatAttributes(entity, 5, true)
    SetPedCombatAttributes(entity, 46, true)
end)
