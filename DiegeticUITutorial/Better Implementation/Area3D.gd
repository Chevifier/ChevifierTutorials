extends Area3D


@onready var sprite3d: Sprite3D = $Sprite3D
@onready var viewport: SubViewport = $Sprite3D/SubViewport


func _unhandled_input(event):
	if event is InputEventMouse:
		# Handled via _on_input_event.
		return
	viewport.push_input(event)

func _on_input_event(_camera: Camera3D, event: InputEvent, pos: Vector3, _normal: Vector3, _shape_idx: int):
	# Position of the event in Sprite3D local coordinates.
	var texture_3d_position = sprite3d.get_global_transform().affine_inverse() * pos
	if !is_zero_approx(texture_3d_position.z):
		# Discard event because event didn't happen on the side of the Sprite3D.
		return
	# Position of the event relative to the texture.
	var texture_position: Vector2 = Vector2(texture_3d_position.x, -texture_3d_position.y) / sprite3d.pixel_size - sprite3d.get_item_rect().position
	# Send mouse event.
	var e: InputEvent = event.duplicate()
	if e is InputEventMouse:
		e.set_position(texture_position)
		e.set_global_position(texture_position)
		viewport.push_input(e)

func _on_button_pressed():
	print("Button pressed")

func _on_line_edit_text_submitted(new_text):
	print("Text submitted: ", new_text)


func _on_item_list_item_selected(index: int) -> void:
	print("Item index: %d Selected" % index)


func _on_check_box_toggled(toggled_on: bool) -> void:
	var t = "Checkbox On" if toggled_on else "Checkbox Off"
	print(t)
