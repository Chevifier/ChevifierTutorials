@tool
extends BouncySprite

func _on_direction_changed(node: Object) -> void:
	var new_color = Color(randf(),randf(),randf())
	self_modulate = new_color
