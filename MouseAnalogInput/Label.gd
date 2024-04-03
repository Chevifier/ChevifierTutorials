extends Label


func _on_mouse_analog_input_analog_input(analog: Vector2) -> void:
	text = "X: %.2f, Y: %.2f" % [analog.x,analog.y]
