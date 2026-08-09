extends Node3D

@export_group("Flip Animation")
@export var start_y: float
@export var end_y: float
@export var flip_time: float

@onready var front: AnimatedSprite3D = $Front

var is_flipping = false
var timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
