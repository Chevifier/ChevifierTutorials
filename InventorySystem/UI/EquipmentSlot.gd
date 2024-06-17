extends TextureRect

enum Type{
	Default,
	Head,
	Hand,
	Weapon,
	Chest,
	Pants,
	Feet
}
@export var slot_type:Type = 0
@onready var icon = $icon
#setup the slot data
func set_slot(data:Dictionary):
	if data.is_empty():
		tooltip_text = ""
		icon.texture = null
		return
	tooltip_text = GameData.get_item_name(data.item_name)
	icon.texture = Inventory.get_item_texture(data.item_name)

#begin of a drag from this slot generate data needed
func _get_drag_data(at_position: Vector2) -> Variant:
	if Inventory.equipment[slot_type].is_empty():
		return
	var prev = Control.new()
	var picon = TextureRect.new()
	picon.position -= Vector2(32,32)
	picon.texture = icon.texture
	prev.add_child(picon)
	set_drag_preview(prev)
	modulate = Color(1,1,1,0.5)
	var data = Inventory.equipment[slot_type].duplicate()	
	data.from_slot = slot_type
	data.dragged = self
	return data

#check if data can be dropped on this slot
#useful for equipment i.e swords can only go in weapon slot
#just returning true here
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if GameData.get_item_type(data.item_name) == slot_type:
		return true
	return false
#drop the data on this slot
#make all changes here 
func _drop_data(at_position: Vector2, data: Variant) -> void:
	Inventory.equip_item(data.from_slot,slot_type,data)
	set_slot(Inventory.equipment[slot_type])
	data.dragged.set_slot(Inventory.inventory[data.from_slot])
#end of a drag
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate = Color(1,1,1,1)
