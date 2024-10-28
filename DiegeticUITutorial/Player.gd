extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var cam = $cam
var mouse = Vector2()
var HIGH_MOUSE_SPEED = 10
var LOW_MOUSE_SPEED = 2
var current_mouse_speed = HIGH_MOUSE_SPEED
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	#Check for ESC key press
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			current_mouse_speed = LOW_MOUSE_SPEED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			current_mouse_speed = HIGH_MOUSE_SPEED
	#If mouse visible return(prevent movement)
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var velz = input_dir.y * transform.basis.z * SPEED
	var velx = input_dir.x * transform.basis.x * SPEED
	rotation_degrees.y -= mouse.x * current_mouse_speed * delta
	cam.rotation_degrees.x -= mouse.y * current_mouse_speed * delta
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -80,80)
	velocity = velx + velz + Vector3(0,-gravity,0)
	move_and_slide()
	mouse = Vector2()

#get mouse relative for rotation
func _input(event):
	if event is InputEventMouseMotion:
		mouse = event.relative
		
		
		
