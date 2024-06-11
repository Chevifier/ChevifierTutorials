extends PopupMenu
var current_slot = null
func open(slot):
	current_slot = slot
	position = current_slot.global_position + Vector2(32,0)
	popup()

func _on_index_pressed(index: int) -> void:
	match(index):
		0:
			#restore health
			Inventory.remove_item(current_slot.name,1)
		1:
			Inventory.spit_slot(current_slot.name)
		2:
			Inventory.remove_item(current_slot.name,1)
		3:
			var quantity = Inventory.inventory[current_slot.name].quantity
			Inventory.remove_item(current_slot.name,quantity)
		
