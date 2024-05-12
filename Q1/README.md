# Q1 - Nickolas Cerrone

Changes:
- Introduced descriptive variable names to replace 
  "magic numbers" used in the script. This both
  increases readability and descreases the chance
  of bugs in the future.
- Implemented a nil check for the player object.
  These checks reduce runtime errors and allows us
  to have defined behavior when these situations occur.

```Lua
-- Storage variables
local STORAGE_KEY = 1000
local STORAGE_VALUE_RESET = -1
local STORAGE_VALUE_ACTIVE = 1

-- Event variables
local DELAY_MS = 1000

local function releaseStorage(player)
    -- Reset the storage value if the player is valid
    if player ~= nil then
        player:setStorageValue(STORAGE_KEY, STORAGE_VALUE_RESET)
    end
end

function onLogout(player)
    -- If the player is not valid, return false to indicate an unsuccessful logout.
    if player == nil then
        return false
    end

    -- If the player's storage value is active, create an event to reset it
    if player:getStorageValue(STORAGE_KEY) == STORAGE_VALUE_ACTIVE then
        addEvent(releaseStorage, DELAY_MS, player)
    end

    -- Return true to indicate a successful logout
    return true
end
```