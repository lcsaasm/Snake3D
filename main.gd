extends Node

@onready var camera_pivot: Node3D = $CameraPivot
@onready var player: CharacterBody3D = $Player

@export var camera_sensitivity: float = 0.25

var camera_lock_flag: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	camera_pivot.position = player.position

func _unhandled_input(event: InputEvent) -> void:
	if not camera_lock_flag and event is InputEventMouseMotion:
		camera_pivot.rotation_degrees.x -= event.relative.y * camera_sensitivity
		camera_pivot.rotation_degrees.y -= event.relative.x * camera_sensitivity
	
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE)
		camera_lock_flag = not camera_lock_flag
