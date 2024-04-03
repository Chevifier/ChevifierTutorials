extends CanvasLayer

@export var target:Node
@export var gauge:ProgressBar
@export var label:Label

func _process(delta: float) -> void:
	var speed = target.current_speed
	var max_speed = target.MAX_SPEED
	gauge.value = (speed/max_speed) * 100
	label.text = str(round(speed)) + "m/s"
