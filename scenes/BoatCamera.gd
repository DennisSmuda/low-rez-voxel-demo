extends Camera3D

@onready var boat = get_node("../Boat")

func _process(_delta):
	position = lerp(position, boat.position + Vector3(1.9, 1.5, 1.3), 0.02)
	
	if Input.is_action_just_pressed("ui_down"):
		size += 0.1
	if Input.is_action_just_pressed("ui_up"):
		size -= 0.1
