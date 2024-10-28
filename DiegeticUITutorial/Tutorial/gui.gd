extends Node3D





@onready var display = $display
@onready var viewport = $viewport
@onready var area = $area

var mesh_size = Vector2()

var mouse_entered = false
var mouse_held = false
var mouse_inside = false

var last_mouse_pos_3D = null
var last_mouse_pos_2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	area.mouse_entered.connect(func(): mouse_entered = true)
	viewport.set_process_input(true)
	
	
func _unhandled_input(event):
	var is_mouse_event = false
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		is_mouse_event = true
		
	if mouse_entered and (is_mouse_event or mouse_held):
		handle_mouse(event)
	elif not is_mouse_event:
		viewport.push_input(event,true)
	
	
func handle_mouse(event):
	mesh_size = display.mesh.size
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		mouse_held = event.pressed
	
	var mouse_pos3D = find_mouse(event.global_position)
	
	mouse_inside = mouse_pos3D != null
	
	if mouse_inside:
		mouse_pos3D = area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos_3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos_3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO
	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	
	#convert from -meshsize/2 to meshsize/2
	mouse_pos2D.x += mesh_size.x / 2
	mouse_pos2D.y += mesh_size.y / 2
	#convert to 0 to 1
	mouse_pos2D.x = mouse_pos2D.x / mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / mesh_size.y
	#convert to viewport range 0 to veiwport size
	mouse_pos2D.x = mouse_pos2D.x * viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * viewport.size.y
	
	event.position = mouse_pos2D
	event.global_position = mouse_pos2D
	
	if event is InputEventMouseMotion:
		if last_mouse_pos_2D == null:
			event.relative = Vector2(0,0)
		else:
			event.relative = mouse_pos2D - last_mouse_pos_2D
		
	last_mouse_pos_2D = mouse_pos2D
	
	viewport.push_input(event)
	

func find_mouse(pos:Vector2):
	var camera = get_viewport().get_camera_3d()
	
	var dss:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	
	var rayparam = PhysicsRayQueryParameters3D.new()
	rayparam.from = camera.project_ray_origin(pos)
	var dis = 5
	rayparam.to = rayparam.from + camera.project_ray_normal(pos) * dis
	rayparam.collide_with_bodies = false
	rayparam.collide_with_areas = true
	
	var result = dss.intersect_ray(rayparam)
	if result.size() > 0:
		return result.position
	else:
		return null
	
	
	
	
	
	

	
	
