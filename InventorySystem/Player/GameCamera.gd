extends Node3D

@export var target:Node
@export var Rotation_Min = -80
@export var Rotation_Max = 80
@onready var spring_arm = $SpringArm3D
@export var offset = Vector3()
var mouse_input = Vector2()

func _ready():
	spring_arm.add_excluded_object(target.get_rid())
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	transform.origin = target.transform.origin + offset
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		return
	rotation_degrees.y -= mouse_input.x
	spring_arm.rotation_degrees.x -= mouse_input.y
	spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x,Rotation_Min,Rotation_Max)
	mouse_input = Vector2()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative
