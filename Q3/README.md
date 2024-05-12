# Q3 - Nickolas Cerrone

Changes:
- Changed function name to 'removeMemberFromParty' to 
  better describe its functionality.
- Add 'local' keyword to the player variable declaration 
  to ensure it is scoped correctly within the function.
- Add error handling and nil checks to prevent runtime 
  errors and allow for better defined behavior.
- Optimized performance by moving the creation of the 
  Player object to outside of the loop. This prevents 
  the program from initializing it multiple times.
- Improved readability by using more descriptive variables
  in the loop.

```Lua
function removeMemberFromParty(playerId, membername)
    -- Create the player and check if they are nil
    local player = Player(playerId)
    if player == nil then
        print("Player with ID " .. playerId " could not be found.")
        return
    end

    -- Get the player's party and check if it is nil
    local party = player:getParty()
    if party == nil then
        print("Party of player with ID " .. playerId .. " could not be found.")
        return
    end

    -- Define outside of the loop for better performance
    local memberToRemove = Player(membername)

    for k, member in pairs(party:getMembers()) do
        if member == memberToRemove then
            party:removeMember(memberToRemove)
            break -- Break out of the loop to prevent unnecessary iterations
        end
    end
end
```
