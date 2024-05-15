-- notes first attempt with isSIghtClear didn't work. that doesn't seem to check if there is a blocking object
-- Server doesn't expose any direct method to determind of a tile is blocking, but the lib/core/tile.lua provides an Tile.isWalkable script
-- Rather confusingly, this codebase uses a combination of exposing things to lua through c++ and creating it's own lua files to handle some fucntions (such as isWalkable)
-- We take a similar aproach to the Q5 spell and will trigger this spell on a delay. 
-- The dash mechanics are: 1. teleport 4 tiles forwards 2. teleport 1 tile twice more to slow down

local dash_interval = 100
local full_distance = 4
local slow_distance = 1

function calculateNewPosition(position, direction, distance)
    local newPosition = Position(position) -- Create a copy to avoid unwanted modification

    if direction == 0 then
        newPosition.y = newPosition.y - distance
    elseif direction == 1 then
        newPosition.x = newPosition.x + distance
    elseif direction == 2 then
        newPosition.y = newPosition.y + distance
    elseif direction == 3 then
        newPosition.x = newPosition.x - distance
    end

    return newPosition
end

function performDash(creatureId, distance) 
    -- Creature must be instantiated each time as it goes out of scope after onCastSpell returns
    local creature = Creature(creatureId)
    if creature == nil then
        return
    end

    local direction = creature:getDirection()
    local originalPosition = creature:getPosition()

    local intermediatePosition = nil
    local lastWalkablePosition = nil -- To keep track of the last walkable position

    -- Check each intermediate tile for walkability
    for i = 1, distance do
        intermediatePosition = calculateNewPosition(originalPosition, direction, i)
        local intermediateTile = Tile(intermediatePosition)
        if intermediateTile:isWalkable() then
            lastWalkablePosition = Position(intermediatePosition) -- Update last walkable position
        else
            break -- Exit the loop if a non-walkable tile is found
        end
    end

    -- Teleport if any intermediate possitions were walkable
    if lastWalkablePosition ~= nil then
        creature:teleportTo(lastWalkablePosition)
    end
end

function onCastSpell(creature, variant)
    print("dash spell cast!")

    local creatureId = creature:getId()

    -- Start dash routine
    performDash(creatureId, full_distance)
    addEvent(performDash, dash_interval, creatureId, slow_distance)
    addEvent(performDash, 2 * dash_interval, creatureId, slow_distance)

	return true
end
