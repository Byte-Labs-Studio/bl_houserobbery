---@alias Id number
---@alias Source number|string
---@alias InteriorName string
---@alias BlackOut boolean
---@alias SkipObjects table<string, boolean>
---@alias coords vector4

---@class EnterHouse table -- The table containing interior data.
--- @field id Id -- A unique identifier for the interior.
--- @field interiorName InteriorName -- The name of the interior.
--- @field blackOut BlackOut -- Whether the blackout mode is enabled.
--- @field skipObjects SkipObjects -- A table of objects to skip, where keys are object names and values are booleans.
--- @field coords coords

---@class ConfigHouses
--- @field label string
--- @field coords coords

---@class Houses
--- @field id Id
--- @field label string
--- @field coords coords
--- @field cooldown boolean
--- @field cameras {coords: vector3, rotation: vector3, bucket: number}[]
--- @field private private {insidePlayers: table<string, boolean>, oldBucket: number, interior: InteriorName, skipObjects: table<string, boolean>}
--- @field isPlayerInside fun(source: Source): boolean --check if player is inside the house
--- @field destroy function --destroy class data
--- @field getInsidePlayers fun(): number[] --get inside players
--- @field spawnPeds function --spawn peds
--- @field isHouseEmpty fun(): boolean --check if house is empty
--- @field onPlayerSpawn fun(source: Source, init: boolean) --trigger if player enter, init means if that player the one who entered the house when created
--- @field playerEnter fun(source: Source, init: boolean): boolean|nil --enter house
--- @field takeObject fun(source: Source, objectIndex: number) -- take house object and sync it with inside players
--- @field registerCamera fun(data: {coords: vector3, rot: vector3}) --register camera
--- @field syncBlackOut function --sync blackout with players
--- @field playerExit fun(source: Source): boolean --exit house

---@class RegisterHouse
--- @field id Id
--- @field blackOut BlackOut -- Whether the blackout mode is enabled.
--- @field coords coords


---@class Peds
--- @field chance number
--- @field model number
--- @field weapon number
--- @field coords vector4
--- @field anim {dict: string, name: string}

---@class Objects
--- @field item string
--- @field model number
--- @field position vector4
--- @field rotation? vector4
--- @field defaultModel? number
--- @field camera? boolean
--- @field freeze? boolean
--- @field anim {dict: string, name: string}