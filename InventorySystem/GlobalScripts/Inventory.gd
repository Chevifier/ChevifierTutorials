extends Node
signal updated()
var inventory = {}
var equipment = {}
#total slots
const SLOTS = 16
const EQUIP_SLOTS = 7
func _ready() -> void:
	initailize()
	GameData.load_game_data(GameData.file_path)
	create_sample_inventory()

#create all 16 empty slots
func initailize():
	for i in SLOTS:
		inventory["slot"+str(i)] = {}
	inventory["equipment"] = {}
	for equip_slot in range(EQUIP_SLOTS): #7 types of equipment slots
		equipment[equip_slot] = {}
		
#sample inventory for testing
func create_sample_inventory():
	for slot in inventory:
		if randf() >= 0.9:
			continue
		var items = ["apple", "stone", "stick", "cloth","wooden_sword"]
		items.append_array(["red_hat","blue_shirt"])
		var item = items.pick_random()
		inventory[slot] = {
			"item_name": item,
			"type": GameData.get_item_type(item)
		}
		if GameData.get_stackable(item):
			inventory[slot]["quantity"] = randi_range(1,10)
		else:
			inventory[slot]["quantity"] = 1
	inventory.slot0 = GameData.get_item("red_hat",1)
	inventory.slot1 = GameData.get_item("wooden_sword",1)
	inventory.slot2 = GameData.get_item("blue_shirt",1)
	inventory.slot3 = GameData.get_item("basic_shoes",1)
	updated.emit()

#Equip and item remving it from thew inventory slot and add it to the equipment slot
func equip_item(from_slot,equip_slot,item):
	if equipment[equip_slot].is_empty():
		equipment[equip_slot] = item
		inventory[from_slot].clear()
	else:
		var equiped_item = equipment[equip_slot].duplicate()
		equipment[equip_slot] = item
		inventory[from_slot] = equiped_item
#remove item from equipment slot put in inventory
func unequip_item(equip_slot,to_slot = ""):
	if to_slot != "":
		if inventory[to_slot].is_empty():
			inventory[to_slot] = equipment[equip_slot].duplicate()
			equipment[equip_slot].clear()
			return
		else:
			return
	#else put in first free slot
	for slot in inventory:
		if inventory[slot].is_empty():
			inventory[slot] = equipment[equip_slot]
			equipment[equip_slot].clear()
			break
		#else no space to unequip i.e do nothing
		#could do a notification here to player that their inventory is full
#Add item to any slot that already has the item
#else add it to the first empty slot
func add_item(item_name,quantity):
	var empty_slot = ""
	var item_added = false
	for slot in inventory:
		if inventory[slot].is_empty():
			if empty_slot == "":
				empty_slot = slot
			continue
		if  inventory[slot].item_name == item_name:
			inventory[slot].quantity += quantity
			item_added = true
			break
	if item_added:
		updated.emit()
		return
	inventory[empty_slot] = {
		"item_name": item_name,
		"quantity" : quantity,
		"type": GameData.get_item_type(item_name)
	}
	updated.emit()

#remove quantity of item from slot
func remove_item(slot,quantity):
	inventory[slot].quantity -= quantity
	if inventory[slot].quantity == 0:
		inventory[slot].clear()
	updated.emit()

#move item from slot to another slot
#if slot is empty add item to that slot
#if slot is same item increase quantity
#else swap items 
func move_item(quantity,from_slot,to_slot):
	var item = inventory[from_slot]
	if inventory[to_slot].is_empty():
		inventory[to_slot] = {
			"item_name" : item.item_name,
			"quantity" : quantity
		}
		inventory[from_slot].quantity -= quantity
	elif inventory[to_slot].item_name == item.item_name:
		if GameData.get_stackable(item.item_name):
			inventory[to_slot].quantity += quantity
			inventory[from_slot].quantity -= quantity
	else:
		swap_item(from_slot,to_slot)
		
	if inventory[from_slot].quantity <= 0:
		inventory[from_slot].clear()
	updated.emit()
	
#take half of item from slot and place it in first empty slot
func spit_slot(spliting_slot):
	var data = inventory[spliting_slot].duplicate()
	if data.quantity == 1 or data.is_empty():
		return
	data.quantity = round(data.quantity/2)
	for slot in inventory:
		if inventory[slot].is_empty():
			move_item(data.quantity,spliting_slot,slot)
			break
	updated.emit()

#swap slot items
func swap_item(from_slot, to_slot):
	var item_to_move = inventory[from_slot]
	var item_to_replace = inventory[to_slot]
	inventory[to_slot] = item_to_move
	inventory[from_slot] = item_to_replace

#get a texture for the item
func get_item_texture(item_name:String):
	var icon = load(GameData.get_icon_path(item_name))
	if icon:
		return icon
	else:
		return load(GameData.default_icon)
