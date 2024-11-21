## items

## Ox

```lua
    ['toaster'] = {
		label = 'Toaster',
		weight = 1000,
	},
    ['boombox'] = {
		label = 'Boom box',
		weight = 1000,
	},
    ['television1'] = {
		label = 'Old Tv',
		weight = 4000,
	},
    ['vcr'] = {
		label = 'Videocassette Recorder',
		weight = 2000,
	},
    ['television2'] = {
		label = 'Flat Tv',
		weight = 2500,
	},
    ['console'] = {
		label = 'Console',
		weight = 1000,
	},
    ['microwave'] = {
		label = 'Micro Wave',
		weight = 5000,
	},
    ['breachingdevice'] = {
		label = 'Breaching Device',
		weight = 5000,
	},
```

## others

```lua
['toaster'] = {
    name = 'toaster',
    label = 'Toaster',
    weight = 1000,
    type = 'item',
    description = 'A tool to dig with.',
    unique = true,
    useable = true,
    image = 'dig_tool.png',
},
['boombox'] = {
    name = 'boombox',
    label = 'Boom box',
    weight = 1000,
    type = 'item',
    description = 'A portable speaker system.',
    unique = true,
    useable = true,
    image = 'boombox.png',
},
['television1'] = {
    name = 'television1',
    label = 'Old Tv',
    weight = 4000,
    type = 'item',
    description = 'A vintage television set.',
    unique = true,
    useable = false,
    image = 'old_tv.png',
},
['vcr'] = {
    name = 'vcr',
    label = 'Videocassette Recorder',
    weight = 2000,
    type = 'item',
    description = 'A device for playing VHS tapes.',
    unique = true,
    useable = true,
    image = 'vcr.png',
},
['television2'] = {
    name = 'television2',
    label = 'Flat Tv',
    weight = 2500,
    type = 'item',
    description = 'A modern flat-screen television.',
    unique = true,
    useable = false,
    image = 'flat_tv.png',
},
['console'] = {
    name = 'console',
    label = 'Console',
    weight = 1000,
    type = 'item',
    description = 'A gaming console.',
    unique = true,
    useable = true,
    image = 'console.png',
},
['microwave'] = {
    name = 'microwave',
    label = 'Micro Wave',
    weight = 5000,
    type = 'item',
    description = 'A microwave oven for heating food.',
    unique = true,
    useable = true,
    image = 'microwave.png',
},
['breachingdevice'] = {
    name = 'breachingdevice',
    label = 'Breaching Device',
    weight = 5000,
    type = 'item',
    description = 'A high-tech device used to disable security systems, hack cameras, and unlock doors during a robbery. Essential for bypassing security measures without detection.',
    unique = true,
    useable = true,
    image = 'breachingdevice.png',  -- You can change the image to something that matches the item visually
},
```

# Exports

## Server

### `getActiveHouses()`
**Description:**  
Returns a list of all active houses in the server.

**Returns:**  
- `table` — An array containing all active house instances.

---

### `enterClosestHouse(source)`
**Description:**  
Teleports the specified player (identified by `source`) to the closest house.

**Parameters:**  
- `source` (`number`): The player's unique identifier (source).

**Returns:**  
- `void` — This function doesn't return anything.

---

### `getActiveHouseByCoords(coords)`
**Description:**  
Fetches the active house instance at the given coordinates.

**Parameters:**  
- `coords` (`vector3`): The coordinates to check for the active house.

**Returns:**  
- `Houses|nil` — Returns the `Houses` instance if a house is found at the specified coordinates, or `nil` if no active house exists at the location.

---

### `getPlayerCurrentHouse(source)`
**Description:**  
Returns the active house instance the player (identified by `source`) is currently inside.

**Parameters:**  
- `source` (`number`): The player's unique identifier (source).

**Returns:**  
- `Houses|nil` — The `Houses` instance if the player is inside a house, or `nil` if the player is not inside any active house.

---

### `getPlayersInHouse(id: houseId)`
**Description:**  
Returns a list of players currently inside the specified house.

**Parameters:**  
- `id` (`string` or `number`): The unique identifier of the house.

**Returns:**  
- `table` — A table containing the identifiers of players currently inside the house.

# Hooks
## registerHouseHook
The `registerHouseHook` function allows you to add hooks for specific player actions related to houses, such as entering or exiting.

### Parameters:
- **`hookType`**:  
  Type: `'playerEnter' | 'playerExit'`  
  Description: Specifies the type of action to hook into.

- **`func`**:  
  Type: `function(id, coords, interiorName, blackOut, destroy)`  
  Description: The callback function executed when the hook is triggered.  

#### Callback Parameters:
- **`id`**:  
  Type: `number`  
  Description: The unique ID of the house.

- **`coords`**:  
  Type: `vector3`  
  Description: The exterior coordinates of the house.

- **`interiorName`**:  
  Type: `string`  
  Description: The name of the interior the player is trying to enter.

- **`blackOut`**:  
  Type: `boolean`  
  Description: Indicates whether the house is in blackout mode.

- **`destroy`**:  
  Type: `function`  
  Description: Call this function to destroy the house and remove all players inside.

#### Usage:
```lua
registerHouseHook(hookType, func)
```

# Events

## Client-Side (Networked)

### **`bl_houserobbery:client:onPlayerEnter`**
Triggered when a player enters a house.

### **`bl_houserobbery:client:onPlayerExit`**
Triggered when a player exits a house.