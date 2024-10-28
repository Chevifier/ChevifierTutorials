extends VBoxContainer

signal code_successfull
@onready var digits = $Digits;

@export var required_4_digit_code := "1379"
var keys_count = 0
var keypad_keys = [ "1","2","3",
					"4","5","6",
					"7","8","9",
					"*","0","#"]
var keys = ""
func _ready():
	for b in $Buttons.get_children():
		b.pressed.connect(on_button_pressed.bind(b.get_index()))

func on_button_pressed(id):
	if id == 9:
		get_parent().get_parent().close_request.emit()
		return
	keys_count += 1
	keys += keypad_keys[id]
	digits.text = keys.lpad(4,"0")
	if keys_count >= 4:
		if keys == required_4_digit_code:
			get_parent().get_parent().code_success.emit()
		#check if right PASSCODE
		digits.text = "0000"
		keys = ""
		keys_count = 0
		
