extends Node3D

@export_group("Flip Animation")
@export var min_y: float
@export var max_y: float
@export var flip_time: float

@onready var front: AnimatedSprite3D = $Front

var is_flipping = false
var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_flipping = true
	rotation.x = 0
	position.y = min_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_flipping:
		return
	
	timer += delta
	
	if timer > flip_time:
		is_flipping = false
		rotation.x = deg_to_rad(180)
		position.y = min_y
		return
	
	rotation.x = timer / flip_time * deg_to_rad(180)
	position.y = min_y + (max_y - min_y) * abs(sin(rotation.x))
