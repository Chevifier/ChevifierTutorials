extends Node3D
@export var target:Node3D


func _process(delta: float) -> void:
	position = lerp(position,target.position,20*delta)
	rotation.x = lerp_angle(rotation.x,target.rotation.x,1*delta)
	rotation.y = lerp_angle(rotation.y,target.rotation.y,2*delta)
	rotation.z = lerp_angle(rotation.z,target.rotation.z,2*delta)
