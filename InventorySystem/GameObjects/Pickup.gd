extends Area3D

@export var pickup_name = ""

@export var amount := 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Inventory.add_item(pickup_name,amount)
		queue_free()
