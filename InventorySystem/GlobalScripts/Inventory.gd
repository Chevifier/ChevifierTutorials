extends Node
signal updated()
var inventory = {}
#total slots
const SLOTS = 16
#Sample icons Note use a config file or some external file instead
@onready var icons = {
	"stick" : preload("res://UI/icons/stick_icon.tres"),
	"box" : preload("res://UI/icons/box_icon.tres"),
	"stone": preload("res://UI/icons/stone_icon.tres"),
	"apple": preload("res://UI/icons/apple_icon.tres"),
	"cloth": preload("res://UI/icons/cloth_icon.tres")
}
func _ready() -> void:
	initailize()
	create_sample_inventory()

#create all 16 empty slots
func initailize():
	for i in SLOTS:
		inventory["slot"+str(i)] = {}

#sample inventory for testing
func create_sample_inventory():
	for slot in inventory:
		if randf() >= 0.5:
			continue
		var items = ["Apple", "Stone", "Stick", "Cloth"]
		inventory[slot] = {
			"item_name": items.pick_random(),
			"quantity" : randi_range(1,10)
		}
	updated.emit()

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
		"quantity" : quantity
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
	var item = inventory[from_slot].item_name
	if inventory[to_slot].is_empty():
		inventory[to_slot] = {
			"item_name" : item,
			"quantity" : quantity
		}
		inventory[from_slot].quantity -= quantity
	elif inventory[to_slot].item_name == item:
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
	return icons[item_name.to_lower()]
