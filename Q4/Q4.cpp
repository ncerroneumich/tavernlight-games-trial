/*
Q4 - Nickolas Cerrone

Changes:
- Added boolean to track the ownership of the player
  pointer. This allows us to assess whether or not
  the memory should be cleaned up at various points
  within the program.
- Added various delete statements to clean up
  memory if it had been created in the function's
  scope. This prevents any memory leaks. Ideally
  the function removes any usage of raw pointers
  and moves over to smart pointers for memory
  management.
*/

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    bool playerCreated = false; // Tracks if a player was created

    if (!player) {
        player = new Player(nullptr);
        
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player; // Clean up created player on early return
            return;
        }

        playerCreated = true; // Set playerCreate to true for future memory clean up
    }

    Item* item = Item::CreateItem(itemId);

    if (!item) {
        if (playerCreated) {
            delete player; // Clean up created player on early return
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    // Clean up created player
    if (playerCreated) {
        delete player;
    }
}