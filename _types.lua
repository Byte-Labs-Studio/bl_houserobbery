---@alias Id string
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


---@class RegisterHouse
--- @field id Id
--- @field coords coords

---@class Peds
--- @field chance number
--- @field model number
--- @field weapon number
--- @field coords vector4
--- @field anim {dict: string, name: string}