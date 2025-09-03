extends Node3D
class_name Turret

const PROJECTILE = preload("res://projectile.tscn")

@onready var timer: Timer = $Timer

@export var target: Node3D
@export var delay: float = 0.25

func _ready() -> void:
	timer.start(delay)
	if target == null:
		print_debug("Error: Turret target not initialized")
		
func shoot() -> void:
	if timer.time_left != 0:
		return
	timer.start(delay)
	var projectile_scene: Node = PROJECTILE.instantiate()
	get_tree().get_root().add_child(projectile_scene)
	projectile_scene.global_position = global_position
	projectile_scene.look_at(target.global_position)
	
func _physics_process(_delta: float) -> void:
	look_at(target.global_position)
