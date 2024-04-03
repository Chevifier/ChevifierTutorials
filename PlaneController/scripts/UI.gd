extends CanvasLayer

var fullscreen = false
func _process(delta: float) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		show()
	else:
		hide()
func _on_full_screen_button_pressed() -> void:
	fullscreen = true if fullscreen == false else false
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_hide_mouse_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
