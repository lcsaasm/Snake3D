extends Node3D

@onready var explosion_area: MeshInstance3D = $ExplosionArea
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

var velocity: Vector3 = Vector3.ZERO
var speed: float = 25.0
var distance_traveled: float = 0
var despawn_range_distance: float = 75.0
var sound: bool = true

func _ready() -> void:
	audio_stream_player.play()
	explosion_area.hide()

func _physics_process(delta: float) -> void:
	if distance_traveled >= despawn_range_distance:
		explosion_area.show()
		explosion_area.scale += Vector3(1, 1, 1)
		
		if sound:
			audio_stream_player_2.play()
			sound = false
	position += (velocity + -transform.basis.z * speed) * delta
	#position += -transform.basis.z * speed * delta
	distance_traveled += abs(speed * delta)
