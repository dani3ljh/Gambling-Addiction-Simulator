extends Node3D

@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3

@onready var interact_area = $Interact
@onready var player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") and interact_area.get_overlapping_bodies().has(player):
		roll_slot(slot1)
		await get_tree().create_timer(1.0).timeout
		roll_slot(slot2)
		await get_tree().create_timer(1.0).timeout
		roll_slot(slot3)

func roll_slot(slot: Node3D):
	#print("Rolling %s" % slot.name)
	slot.rotate_z(deg_to_rad(snapped(randf()*360,45)))
