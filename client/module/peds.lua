local group = 'HOUSEOWNER'
local groupHash = joaat(group)
AddRelationshipGroup(group)

AddStateBagChangeHandler("setHate", nil, function(bagName, key, data)
    if not data then return end
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then return end

    while not HasCollisionLoadedAroundEntity(entity) or not DoesEntityExist(entity) do
        Wait(250)
    end

    local anim = data.anim
    lib.requestAnimDict(anim.dict)
    TaskPlayAnim(entity, anim.dict, anim.name, 1.0, 1.0, -1, 2, 0.0, false, false, false)
    RemoveAnimDict(anim.dict)

    local weapon = data.weapon
    GiveWeaponToPed(entity, weapon, 100, false, false)
    SetPedRandomProps(entity)
    SetPedRelationshipGroupHash(entity, groupHash)
    SetRelationshipBetweenGroups(5, `PLAYER`, groupHash)
    SetRelationshipBetweenGroups(5, groupHash, `PLAYER`)
    SetPedCombatAttributes(entity, 5, true)
    SetPedCombatAttributes(entity, 46, true)
    SetPedCombatAttributes(entity, 54, true)
    Wait(1)
    Entity(entity).state:set('setHate', nil, true)
end)
