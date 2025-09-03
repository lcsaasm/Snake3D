extends Node
class_name Controller

@onready var camera_pivot: Node3D = $"../CameraPivot"
@onready var camera_3d: Camera3D = $"../CameraPivot/Camera3D"

func input_gather() -> InputPackage:
	var input_data: InputPackage = InputPackage.new()
	var input_direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	input_data.direction = (camera_pivot.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if Input.is_action_pressed("interact"):
		input_data.interact = true
	if Input.is_action_pressed("shoot"):
		input_data.shoot = true
	if Input.is_action_pressed("jump"):
		input_data.jump = true
		
	return input_data
