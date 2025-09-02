extends CharacterBody3D
class_name Segment

const TURRET = preload("res://turret.tscn")

var attachment: Node

func bind_turret(target_track: Node3D) -> void:
	if attachment != null:
		return
		
	var turret_scene: Node = TURRET.instantiate()
	turret_scene.position = Vector3(0, 0.75, 0)
	turret_scene.target = target_track
	attachment = turret_scene
	add_child(turret_scene)

func unbind_turret() -> void:
	if attachment == null:
		return
	attachment.queue_free()
	attachment = null
