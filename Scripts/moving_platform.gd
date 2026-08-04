extends RigidBody3D

@export var max_speed: float = 10
@export var max_z: float
@export var min_z: float

var speed: float

# Called when the node enters the scene tree for the first time.
func _ready():
	max_speed = abs(max_speed)
	speed = max_speed

func _integrate_forces(state):
	if position.z < min_z:
		linear_velocity = Vector3.ZERO
		speed = max_speed
	if position.z > max_z:
		linear_velocity = Vector3.ZERO
		speed = -max_speed
	state.apply_force(Vector3(0, 0, speed))
