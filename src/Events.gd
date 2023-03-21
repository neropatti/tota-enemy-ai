# warning-ignore-all:unused_signal
extends Node

# When we switch between a main screen (Menu, Cutscene, Gameplay)
signal changed_screen(from_screen, _to_screen)

# When we want to show the HUD - not controlled by player
signal opened_hud

# When we want to NOT show the HUD - not controlled by player
signal closed_hud

# When the player triggers to open inventory bag
signal opened_inventory

# When the player triggers to close inventory bag
signal closed_inventory

# When the player goes to the storage and triggers to open it
signal opened_storage

# When the player is in storage menu and exits to close it
signal closed_storage

# When the player goes to the workbench and triggers to open it
signal opened_crafting

# When the player is in the craft screen and exits to close it
signal closed_crafting

# When the player initiates a dialogue conversation
signal started_dialogue(conversation_id)

# When the player has pressed to continue to the next line of dialogue
signal dialogue_next_line

# When the dialogue conversation has finished
signal finished_dialogue

# When the game initiaties a (New location)
signal location_announcement_requested(announcement_id)

# When the game initiaties a (New Quest)
signal quest_announcement_requested(announcement_id)

# When the settings screen is triggered in menu
signal opened_settings

# When the settings screen is closed
signal closed_settings

# When the locaton announcement finishes
signal finished_location_announcement

# When the quest announcement finishes
signal finished_quest_announcement

# When the player has accepted to take on a quest
signal quest_accepted(announcement_id)

# When the player has rejected to take on a quest
signal quest_rejected(announcement_id)

# When the player has successfully completed a quest
signal quest_completed

# When the player has failed to complete a quest
signal quest_failed

# --- Inventory Satchel ---

# When the inventory satchel is focused
signal satchel_focused

# When the inventory satchel is full up and cannot take more items
signal satchel_full

# When an item is successfully added to the inventory satchel
signal satchel_item_added(item_id)

# When an item is successfully removed from the inventory satchel
signal satchel_item_removed

# When the player navigates out of the inventory to a separate component (Storage or Craft)
signal satchel_navigated_out

# (NOT USED) When the player navigates back in to the inventory satchel
signal satchel_navigated_in

# When the player decides to exit the menu entirely inside the inventory focus
signal satchel_exit_requested

# When the player selects an item (so its highlighted) inside the inventory satchel
signal satchel_selected_item(item)

# When two items swap positions in the Satchel
signal satchel_swapped_items(item_a_index, item_b_index)

# When the player de-selects an item (so its not highlighted anymore) inside the inventory satchel
signal satchel_deselected_item

# When the player successfully moves an item from storage to the inventory satchel
signal moved_storage_item_to_satchel(item_id)

# When the player successfully moves an item from storage to the inventory satchel
signal moved_crafting_item_to_satchel(item_id)

# --- Notifications ---

signal notification_requested(message, type)

# --- Storage ---

# When the player navigates out of the storage to the inventory satchel
signal storage_navigated_out

# (NOT USED) When the player navigates back in to the storage
signal storage_navigated_in

# When the player decides to exit the menu entirely inside storage
signal storage_exit_requested

# When the player selects an item (so its highlighted) inside storage
signal storage_selected_item(item_id, slot_position)

# When the player de-selects an item (so its NOT highlighted) inside storage
signal storage_deselected_item

# When we want to add some storage items ['WaterskinFull', 'Stick']
signal storage_add_items(items)

# When two items swap positions in the Storage
signal storage_swapped_items(item_a_index, item_b_index)

# When the player successfully moves an item from the inventory satchel to storage
signal moved_satchel_item_to_storage(item_id)

# --- Crafting ---

# When the player navigates out of the crafting to the inventory satchel
signal crafting_navigated_out

# (NOT USED) When the player navigates back in to the crafting focus
signal crafting_navigated_in

# When the player decides to exit the menu entirely inside storage
signal crafting_exit_requested

# When the player selects an item (so its highlighted) inside crafting
signal crafting_selected_item(item_id, slot_position)

# When the player deselects an item in the crafting view
signal crafting_deselected_item

# When we want to add some crafting items ['WaterskinFull', 'Stick']
signal crafting_add_items(items)

# When two items swap positions in the Storage
signal crafting_swapped_items(item_a_index, item_b_index)

# When the player successfully moves an item from the inventory satchel to crafting slots
signal moved_satchel_item_to_crafting(item_id)

#  --- Shared item details

# When an item is focused in Satchel, Storage or Crafting view, let everyone know
signal focused_item(item)

# When an item is selected in Satchel, Storage or Crafting view, let everyone know
signal selected_item(item)

# When an empty slot is selected in Satchel, Storage or Crafting view, let everyone know
signal selected_null_item

# When an empty slot is actioned in Satchel, Storage or Crafting view, let everyone know
signal actioned_null_item

# When an empty slot is discarded in Satchel, Storage or Crafting view, let everyone know
signal discarded_null_item

# When an item is de-selected in Satchel, Storage or Crafting view, let everyone know
signal deselected_item(item)

# When an item is requested to be equipped as a weapon
signal equip_item_requested(item)

# When an item is successfully equipped as a weapon
signal equip_item_success(item)

# When an item is requested to be discarded
signal discard_item_requested(item)

# When an item was successfully discarded
signal discard_item_success(item_uuid)

# When an item failed to be discarded
signal discard_item_failed(item_uuid)

# When an item is requested to be used
signal use_item_requested(item)

# When an item was successfully used upon a request
signal used_item_succeeded(item)

# When an item failed to be used upon a request
signal used_item_failed(item)

# When in a pond, request to fill a waterskin in inventory, if it's in there of course (Can be done once per level)
signal fill_waterskin_requested(item)
signal fill_waterskin_succeeded(item)
signal fill_waterskin_failed(item)

# When the player actions a tent to go to sleep at night
signal go_to_sleep_requested

# Info actions
signal info_requested

# Location actions

# The player has actioned to leave the campsite to play a level
signal home_leave_requested

# The player has forfeited the level to go back home
signal level_forfeit_requested

# The player has reached the end of the level successfully
signal level_finished_requested

# player actions

# When the player has taken damage
signal player_taken_damage(damage)

# When the player has expended stamina by rolling, attacking
signal player_used_stamina(stamina)

# When the HUD has identified that the health is 0, tells everyone the player has been killed
signal player_killed(damage)

# When the player has finished dying
signal player_died

# When it gets too late (3am), the player will pass out
signal player_passed_out

# When the HUD has identified that the stamina is 0, the player should be notified
signal player_stamina_empty(damage)

# When the HUD has identified that the stamina has restored, the player should be notified
signal player_health_restored(health_to_add)

# When the HUD has identified that the stamina has restored, the player should be notified
signal player_stamina_restored

# enemy events

# When an enemy has been killed by the player
signal enemy_killed(enemy_type)

# day/night events
signal day_hour_changed(hour)

# When we are initiating the move to the next day - player: sleeps, dies, passes out
signal moving_to_next_day

# When the player is now on the next day - day += 1
signal moved_to_next_day

# In game actions

# when the player has triggered a move to a new level coordinate
signal moving_to_next_level_coords(current_level_coords, next_level_coords, next_level)

# when the camera has moved to the next level and the player is free to roam
signal moved_to_next_level_coords(next_level_coords)

# when the player has crossed a boundary in previous location to move to a different location (Moorlands > Meadows)
signal moving_to_next_location(location_to_go_to, next_level_coord, direction_came_from)

# when the player has finally moved to a different location and is placed in the next level of that location
signal moved_to_next_location(location_to_go_to, next_level_coords)

# When the player requests to speak to Torion (NPC)
signal speak_to_torion_requested
signal speak_to_torion_success
signal speak_to_torion_failed

# When Torion has finished his pathfinding and reached his destination
signal torion_reached_destination(destination_position)

# When the player requests to start the campfire
signal start_campfire_requested
signal start_campfire_success
signal start_campfire_failed  # missing firewood

# Campfire failed to be initiated (Missing firewood)
signal campfire_extinguished

# When the player has triggered the opening of a chest
signal chest_opened(chest_position, position_to_place_item, forced_item)

# When the player has triggered the slashing of a bush
signal bush_slashed(position_to_place_item, forced_item)

# When the player has fallen down a pit hole
signal player_fell_down_hole

# When the player enters a pond
signal entered_pond
signal exited_pond
signal entered_pond_replenish_requested
signal entered_pond_replenish_success
signal entered_pond_replenish_failed

# When the player tries to collect an item in game
signal take_collectable_requested(item_id)
signal take_collectable_success(item_id)
signal take_collectable_failed(item_id)
