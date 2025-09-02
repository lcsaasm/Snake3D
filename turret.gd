extends Node3D
class_name Turret

@export var target: Node3D

func _ready() -> void:
	if target == null:
		print_debug("Error: Turret target not initialized")
	
func _physics_process(_delta: float) -> void:
	look_at(target.global_position)
