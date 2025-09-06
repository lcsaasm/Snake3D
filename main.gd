extends Node

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var omni_light: OmniLight3D = $OmniLight3D
@onready var mouse_pointer: Area3D = $MousePointer
@onready var player: CharacterBody3D = $Player

@export var camera_sensitivity: float = 0.25
@export var camera_zoom_speed: float = 0.75
@export var camera_zoom_range_multiplier: float = 3

var camera_start_position: Vector3
var camera_lock_flag: bool = false
var camera_drag_flag: bool = false
var mouse_ray_cast: RayCast3D = RayCast3D.new()

var mouse_selection: Node3D
var mouse_left_pressed: bool = false

func _ready() -> void:
	camera_start_position = camera.position
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.target_track = mouse_pointer
	add_child(mouse_ray_cast)
	mouse_ray_cast.collide_with_areas = true

func _process(_delta: float) -> void:
	camera_pivot.position = player.position
	omni_light.position = omni_light.position.move_toward(player.position + -player.basis.z + Vector3.UP, 1)
	
	var mouse_position: Vector2
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		mouse_position = get_viewport().get_mouse_position()
	else:
		mouse_position = get_viewport().size / 2 + Vector2i(0, -150)
		
	mouse_ray_cast.position = camera.project_ray_origin(mouse_position)
	mouse_ray_cast.target_position = camera.project_ray_normal(mouse_position) * 25
	if mouse_ray_cast.is_colliding():
		mouse_pointer.position = mouse_pointer.position.move_toward(mouse_ray_cast.get_collision_point(), 0.5)
	else:
		mouse_pointer.position = mouse_pointer.position.move_toward(mouse_ray_cast.position + mouse_ray_cast.target_position, 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not camera_lock_flag or camera_drag_flag:
			camera_pivot.rotation_degrees.x -= event.relative.y * camera_sensitivity
			camera_pivot.rotation_degrees.y -= event.relative.x * camera_sensitivity
		
	if event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE)
		camera_lock_flag = not camera_lock_flag
	if event.is_action_pressed("scroll_up"):
		camera.position = camera.position.move_toward(Vector3.ZERO, camera_zoom_speed)
	if event.is_action_pressed("scroll_down"):
		camera.position = camera.position.move_toward(camera_start_position * camera_zoom_range_multiplier, camera_zoom_speed)
	
	if event.is_action_pressed("right_click"):
		if mouse_selection != null:
			if mouse_selection is Segment:
				mouse_selection.unbind_turret()
		camera_drag_flag = true
	elif event.is_action_released("right_click"):
		camera_drag_flag = false
		
	if event.is_action_pressed("left_click"):
		mouse_left_pressed = true
	elif event.is_action_released("left_click"):
		mouse_left_pressed = false
		
	if mouse_left_pressed:
		if mouse_selection != null:
			if mouse_selection is Segment:
				mouse_selection.bind_turret(mouse_pointer)
				mouse_selection = null

func _on_mouse_pointer_area_entered(area: Area3D) -> void:
	if area.owner != null:
		mouse_selection = area.owner

func _on_mouse_pointer_mouse_exited() -> void:
	mouse_selection = null
