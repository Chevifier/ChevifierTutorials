extends CharacterBody3D

@export var speed = 20
@export var camera_sensitivity = 0.8
const GRAVITY = -98
const Rotation_Speed = 10
@export var jump_velocity = 40
var y_velocity = 0

@export var camera:Node
@onready var anim = $AnimationPlayer
func _ready():
	pass


func _process(delta):
	var direction = Vector3()
	if Input.is_action_pressed("up"):
		direction -= camera.transform.basis.z
	elif Input.is_action_pressed("down"):
		direction += camera.transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= camera.transform.basis.x
	elif Input.is_action_pressed("right"):
		direction += camera.transform.basis.x
		
	if not is_on_floor():
		y_velocity += GRAVITY * delta
	else: y_velocity = -0.1 #padding to help detect floor
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		y_velocity = jump_velocity
	
	direction.normalized()
	velocity = direction * speed
	velocity.y = y_velocity
		
	
	#rotate player based checked camera
	#rotate player based on camera basis
	if direction.length() > 0: #prevent rotation to 0 if theres no input
		rotation.y = lerp_angle(rotation.y,atan2(-direction.x,-direction.z),Rotation_Speed*delta)

	set_velocity(velocity)
	set_up_direction(Vector3.UP)
	move_and_slide()
	update_animations()
	
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func update_animations():
	if velocity.length() > 0.1:
		anim.play("run")
	else:
		anim.play("idle")

