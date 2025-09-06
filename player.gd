extends CharacterBody3D

const SEGMENT = preload("res://segment.tscn")

@onready var body: Node = $Body

@export var controller: Controller
@export var speed: float = 30.0
@export var jump_velocity: float = 5.0
@export var segment_separation: float = 0.75

var target_track: Node3D = Node3D.new()

func _ready() -> void:
	hide()
	set_collision_layer_value(1, 0)
	var segments: Array[Node] = body.get_children()
	for segment in segments:
		segment.position = position
		segment.set_collision_layer_value(1, 0)

func _physics_process(delta: float) -> void:
	var input_data: InputPackage = controller.input_gather()
	var direction: Vector3 = input_data.direction

	if input_data.interact:
		grow()
	if input_data.shoot:
		shoot()

	if is_on_floor():
		velocity.y = 0
		if input_data.jump:
			velocity.y = jump_velocity
	else:
		velocity.y -= 9.8 * delta
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		look_at(position + Vector3(direction.x, 0, direction.z))
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
	process_segments(delta)
	
func shoot() -> void:
	var segments: Array[Node] = body.get_children()
	for segment in segments:
		if segment.attachment != null and segment.attachment is Turret:
			segment.attachment.shoot(velocity)

func grow(amount: int=1) -> void:
	for i in range(amount):
		var segment_scene: Node = SEGMENT.instantiate()
		segment_scene.position = position
		segment_scene.set_collision_layer_value(1, 0)
		body.add_child(segment_scene)

func process_segments(delta: float) -> void:
	var segments: Array[Node] = body.get_children()
	if len(segments) == 0: return
	process_segment(segments[0], self, 0.25, delta)
	for i in range(1, len(segments)):
		process_segment(segments[i], segments[i - 1], segment_separation, delta)

func process_segment(origen: CharacterBody3D, objetive: CharacterBody3D, separation: float, delta: float) -> void:
	var objetive_direction: Vector3 = origen.position.direction_to(objetive.position)
	var target_position: Vector3 = objetive.position - (separation * objetive_direction)
	origen.velocity = (target_position - origen.position)  / delta
	if origen.position.distance_to(target_position) > 0.0025:
		origen.look_at(target_position)
	origen.move_and_slide()
