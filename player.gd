extends CharacterBody3D

const SEGMENT = preload("res://segment.tscn")

@onready var body: Node = $Body

@export var speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var segment_separation: float = 0.25

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("interact"):
		grow()
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = jump_velocity
	else:
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
	process_segments(delta)
	
func grow(amount: int=1) -> void:
	var segments: Array[Node] = body.get_children()
	for i in range(amount):
		var segment_scene: Node = SEGMENT.instantiate()
		body.add_child(segment_scene)

func process_segments(delta: float) -> void:
	var segments: Array[Node] = body.get_children()
	if len(segments) == 0: return
	process_segment(segments[0], self, delta)
	for i in range(1, len(segments)):
		process_segment(segments[i], segments[i - 1], delta)

func process_segment(origen: CharacterBody3D, objetive: CharacterBody3D, delta: float) -> void:
	var objetive_direction: Vector3 = origen.position.direction_to(objetive.position)
	var target_position: Vector3 = objetive.position - objetive_direction - (segment_separation * objetive_direction)
	origen.velocity = (target_position - origen.position)  / delta
	origen.look_at(target_position)
	origen.move_and_slide()
