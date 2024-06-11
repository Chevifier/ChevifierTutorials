extends PopupMenu

@export var offset = Vector2(32,0)
var selected_slot = null


func open(slot):
	selected_slot = slot
	position = slot.global_position + offset
	popup()
	



func _on_index_pressed(index: int) -> void:
	match index:
		0:#use item
			#do something here
			Inventory.remove_item(selected_slot.name,1)
		1:#split item
			Inventory.split(selected_slot.name)
		2:#remove 1 item
			Inventory.remove_item(selected_slot.name,1)
		3:# delete stack
			var total = Inventory.inventory[selected_slot.name].quantity
			Inventory.remove_item(selected_slot.name,total)
