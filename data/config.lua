return {
    defaultInterior = 'Low Apartment', -- if a house don't have a interior, we'll use this instead as default
    debug = true,
    resetCooldown = 0, -- cooldown time to reset house after robbery, do 0 if you want to remove the cooldown and make house reset on server restart
    defaultStealingAnimation = {
        dict = 'missmechanic',
        name = 'work2_base'
    },
    cameraBreaching = {
        item = 'breachingdevice',
        groups = {
            police = 9
        }
    },
    lockPickItem = 'lockpick',
    
    carryAnimation = {
        dict = 'anim@heists@box_carry@',
        name = 'idle'
    }
}