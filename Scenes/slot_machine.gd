extends Node3D

@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3

@onready var interact_area = $Interact
@onready var player = $"../Player"

var slot1_spinning = false
var slot2_spinning = false
var slot3_spinning = false

var slot1_rotation: float = 0
var slot2_rotation: float = 0
var slot3_rotation: float = 0

var timer_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and interact_area.get_overlapping_bodies().has(player):
		roll_slots()
	
	if slot1_spinning:
		if abs(slot1.rotation.z - slot1_rotation) < 0.1 and not timer_running:
			slot1_spinning = false
			slot1.rotation.z = snappedf(slot1.rotation.z, deg_to_rad(45))
		else:
			slot1.rotate_z(-0.03)
			slot1.rotation.z = fposmod(slot1.rotation.z, deg_to_rad(360))
	
	if slot2_spinning:
		if abs(slot2.rotation.z - slot2_rotation) < 0.1 and not timer_running:
			slot2_spinning = false
			slot2.rotation.z = snappedf(slot2.rotation.z, deg_to_rad(45))
		else:
			slot2.rotate_z(-0.03)
			slot2.rotation.z = fposmod(slot2.rotation.z, deg_to_rad(360))
	
	if slot3_spinning:
		if abs(slot3.rotation.z - slot3_rotation) < 0.1 and not timer_running:
			slot3_spinning = false
			slot3.rotation.z = snappedf(slot3.rotation.z, deg_to_rad(45))
		else:
			slot3.rotate_z(-0.03)
			slot3.rotation.z = fposmod(slot3.rotation.z, deg_to_rad(360))

func roll_slots():
	slot1_spinning = true
	slot2_spinning = true
	slot3_spinning = true
	
	slot1_rotation = deg_to_rad(snapped(randf()*360,45))
	slot2_rotation = deg_to_rad(snapped(randf()*360,45))
	slot3_rotation = deg_to_rad(snapped(randf()*360,45))
	
	timer_running = true
	await get_tree().create_timer(1).timeout
	timer_running = false
