extends Node3D

@export_group("Flip Animation")
@export var min_y: float
@export var max_y: float
@export var flip_time: float

@onready var front: AnimatedSprite3D = $Front

var is_flipping = false
var timer: float = 0
var start_rotation: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_flipping = true
	rotation.x = start_rotation
	position.y = min_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_flipping:
		return
	
	timer += delta
	
	if timer > flip_time:
		is_flipping = false
		start_rotation += deg_to_rad(180)
		rotation.x = start_rotation
		position.y = min_y
		await get_tree().create_timer(1.0).timeout
		# print("flipping")
		is_flipping = true
		timer = 0
		return
	
	rotation.x = start_rotation + timer / flip_time * deg_to_rad(180)
	position.y = min_y + (max_y - min_y) * abs(sin(rotation.x))
