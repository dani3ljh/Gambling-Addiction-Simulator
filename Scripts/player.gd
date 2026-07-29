extends CharacterBody3D

@export_group("Looking")
@export var sensitivity: float = 0.005
@export var min_pitch_deg: float = -90
@export var max_pitch_deg: float = 90

@export_group("Jumping")
@export var jump_velocity: float = 6

@export_group("Movement")
@export var sprint_speed: float = 10
@export var walk_speed: float = 5
@export var acceleration: float = 60
@export var air_control: float = 5
@export var air_resistance: float = 2

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(min_pitch_deg), deg_to_rad(max_pitch_deg))
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# get direction input
	var input_direction: Vector2 = Input.get_vector("right", "left", "down", "up")
	var direction = (head.transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	# calculate movement velocity
	var target_velocity: Vector3 = direction * (sprint_speed if Input.is_action_pressed("sprint") and is_on_floor() else walk_speed)
	var horizontal_velocity: Vector3 = Vector3(velocity.x, 0, velocity.z)
	
	if is_on_floor():
		# grounded movement
		horizontal_velocity = horizontal_velocity.move_toward(target_velocity, acceleration * delta)
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	else:
		# air movement
		if direction:
			horizontal_velocity = horizontal_velocity.move_toward(target_velocity, air_control * delta)
		
		horizontal_velocity = horizontal_velocity.move_toward(Vector3.ZERO, air_resistance * delta)
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	
	move_and_slide()
