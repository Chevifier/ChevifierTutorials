extends Node3D
var open = false

func open_door():
	if open == false:
		$AnimationPlayer.play("activate")
		open = true
	
func close_door():
	if open == true:
		$AnimationPlayer.play_backwards("activate")
		open = false
