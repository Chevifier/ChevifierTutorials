extends Node3D

signal code_success
signal close_request

# The size of the quad mesh itself.
var mesh_size = Vector2()
# Used for checking if the mouse is inside the Area
var is_mouse_inside = false
# Used for checking if the mouse was pressed inside the Area
var is_mouse_held = false
# The last non-empty mouse position. Used when dragging outside of the box.
var last_mouse_pos3D = null
# The last processed input touch/mouse event. To calculate relative movement.
var last_mouse_pos2D = null

@onready var node_viewport = $SubViewport
@onready var display = $display
@onready var node_area = $Area3D
func _ready():
	node_area.mouse_entered.connect(func(): is_mouse_inside = true)
	node_viewport.set_process_input(true)
	
	
func _unhandled_input(event):
	#If mouse is captured ignore calculations and return
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		return
	# Check if the event is a non-mouse/non-touch event
	var is_mouse_event = false
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		is_mouse_event = true

	#if mouse event we need to do our calculation to pass it to the in world viewport
	#else we just pass it as is i.e keyboard event etc
	if is_mouse_event and (is_mouse_inside or is_mouse_held):
		handle_mouse(event)
	elif not is_mouse_event:
		node_viewport.push_input(event,true)



# Handle mouse events inside Area.
func handle_mouse(event):
	#get the size of the mesh. This code only support PlaneMesh and QuadMesh.
	mesh_size = display.mesh.size
	
	# Detect mouse being held to mantain event while outside of bounds. Avoid orphan clicks
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		is_mouse_held = event.pressed

	# Find mouse position in Area
	var mouse_pos3D = find_mouse(event.global_position)
	# Check if the mouse is outside of bounds, use last position to avoid errors
	# NOTE: mouse_exited signal was unrealiable in this situation
	is_mouse_inside = mouse_pos3D != null
	if is_mouse_inside:
		# Convert click_pos from world coordinate space to a coordinate space relative to the Area node.
		# NOTE: affine_inverse accounts for the Area node's scale, rotation, and translation in the scene!
		mouse_pos3D = node_area.global_transform.affine_inverse() * mouse_pos3D
		last_mouse_pos3D = mouse_pos3D
	else:
		mouse_pos3D = last_mouse_pos3D
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO
	# convert the relative event position from 3D to 2D
	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y)
	
	# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
	# We need to convert it into the following range: 0 -> quad_size
	mouse_pos2D.x += mesh_size.x / 2
	mouse_pos2D.y += mesh_size.y / 2
	# Then we need to convert it into the following range: 0 to 1
	mouse_pos2D.x = mouse_pos2D.x / mesh_size.x
	mouse_pos2D.y = mouse_pos2D.y / mesh_size.y

	#Then we convert the position to the following range: 0 to viewport.size
	mouse_pos2D.x = mouse_pos2D.x * node_viewport.size.x
	mouse_pos2D.y = mouse_pos2D.y * node_viewport.size.y
	# Set the event's position and global position.
	event.position = mouse_pos2D
	event.global_position = mouse_pos2D

	# If the event is a mouse motion event...
	if event is InputEventMouseMotion:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_mouse_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos
		else:
			event.relative = mouse_pos2D - last_mouse_pos2D
	# Update last_mouse_pos2D with the position we just calculated.
	last_mouse_pos2D = mouse_pos2D

	#Send the processed input event to the viewport.
	node_viewport.push_input(event)

func find_mouse(pos:Vector2):
	var camera = get_viewport().get_camera_3d()
	var dss:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	# From camera center to the mouse position in the Area
	var rayparam = PhysicsRayQueryParameters3D.new()
	rayparam.collide_with_bodies = false
	rayparam.collide_with_areas = true
	
	rayparam.from = camera.project_ray_origin(pos)
	var dist = 2
	rayparam.to = rayparam.from + camera.project_ray_normal(pos) * dist

	# Manually raycasts the are to find the mouse position
	var result = dss.intersect_ray(rayparam)
	if result.size() > 0:
		return result.position
	else:
		return null
