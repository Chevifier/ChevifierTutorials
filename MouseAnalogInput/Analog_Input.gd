extends Control

@export var RADIUS = 70
@export var DEAD_ZONE = 0.1
var mouse_pos = Vector2()
signal analog_input(analog:Vector2)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.warp_mouse(position)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
		
	var local_mouse = get_local_mouse_position()
	if local_mouse.length() < RADIUS:
		mouse_pos = local_mouse
	else:
		mouse_pos = local_mouse.normalized() * RADIUS
		
	Input.warp_mouse(position+mouse_pos)
	
	var analog = Vector2(mouse_pos.x/RADIUS,-mouse_pos.y/RADIUS)
	
	if analog.length() > DEAD_ZONE:
		analog_input.emit(analog)
	queue_redraw()
	
func _draw() -> void:
	draw_arc(Vector2(0,0),RADIUS,0,360,40,Color.WHITE,5,true)
	draw_circle(Vector2(0,0),DEAD_ZONE*100,Color.RED)
	draw_circle(mouse_pos,10,Color.WHITE)
