extends PanelContainer

@onready var inventory_grid = $GridContainer

func _ready() -> void:
	hide()
	Inventory.updated.connect(load_inventory)
	load_inventory()
	


func load_inventory():
	for child in inventory_grid.get_children():
		var data = Inventory.inventory[child.name]
		child.set_slot(data)

	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if visible == false:
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		