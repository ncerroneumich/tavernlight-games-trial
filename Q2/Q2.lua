--[[
Q2 - Nickolas Cerrone

Changes:
- Now handles multiple guilds instead of just printing
  the first result from the database query. This change
  makes the function's behavior more accurately reflect
  its name.
- Improved error handling by checking if the resultId
  from the query is nil and then terminating the function 
  early with an appropriate error message. This allows us
  to avoid runtime errors and have better defined behavior.
- Removed the use of an undefined 'result' variable. 
  For simplicity, assume db is a globally defined
  database and we can retrieve query results from
  it directly with getString and resultId.
- Added explicit assumptions about the database API
  through comments in the function.
]]

function printSmallGuildNames(memberCount)
  local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
  local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

  -- Assumes a nil result Id means the query failed
  if resultId == nil then
      print("Query failed!")
      return
  end

  -- Iterate through all resulting guild names and print them out
  while true do
      -- Assumes db.getString fetches the next result and returns nil if no further results exist
      local guildName = db.getString(resultId, "name")

      -- If the guild name is nil, we have reached the end of our results
      if guildName == nil then
          break
      end

      print(guildName)
  end

  -- Free up any memory allocated by the database query
  db.free(resultId) -- Assumes the database requires manual memory clean up
end