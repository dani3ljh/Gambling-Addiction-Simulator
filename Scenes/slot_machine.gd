extends Node3D

@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3

@onready var interact_area = $Interact
@onready var player = $"../Player"

@onready var slots = [
	{"node": slot1, "spinning": false, "target_rotation": 0, "timer_running": false},
	{"node": slot2, "spinning": false, "target_rotation": 0, "timer_running": false},
	{"node": slot3, "spinning": false, "target_rotation": 0, "timer_running": false}
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and interact_area.get_overlapping_bodies().has(player):
		roll_slots()
	
	for slot in slots:
		if not slot.spinning:
			continue
		
		if not slot.timer_running and abs(slot.node.rotation.z - slot.target_rotation) < 0.1:
			slot.spinning = false
			slot.node.rotation.z = snappedf(slot.node.rotation.z, deg_to_rad(45))
			continue
		
		slot.node.rotate_z(-0.03)
		slot.node.rotation.z = fposmod(slot.node.rotation.z, deg_to_rad(360))

func roll_slots():
	for slot in slots:
		slot.spinning = true
		slot.target_rotation = deg_to_rad(snappedf(randf()*360, 45))
		slot.timer_running = true
	
	await get_tree().create_timer(0.5).timeout
	
	for slot in slots:
		slot.timer_running = false
