extends Node3D

@onready var explosion_area: MeshInstance3D = $ExplosionArea

var speed: float = 25.0

var distance_traveled: float = 0
var despawn_range_distance: float = 75.0

func _ready() -> void:
	explosion_area.hide()

func _physics_process(delta: float) -> void:
	if distance_traveled >= despawn_range_distance:
		explosion_area.show()
		explosion_area.scale += Vector3(1, 1, 1)
	position += -transform.basis.z * speed * delta
	distance_traveled += abs(speed * delta)
