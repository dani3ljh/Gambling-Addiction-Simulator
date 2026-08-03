extends Node3D

@onready var slot1 = $Slot1
@onready var slot2 = $Slot2
@onready var slot3 = $Slot3

@onready var interact_area = $Interact
@onready var player = $"../Player"
@onready var score_label = $"../CanvasGroup/ScoreLabel"

enum Symbol {
	SEVEN,
	CHERRY,
	BELL,
	BAR
}

@onready var slots = [
	{"node": slot1, "spinning": false, "target_rotation": 0, "timer_running": false},
	{"node": slot2, "spinning": false, "target_rotation": 0, "timer_running": false},
	{"node": slot3, "spinning": false, "target_rotation": 0, "timer_running": false}
]

var symbol_list: Array[Symbol] = [Symbol.SEVEN, Symbol.CHERRY, Symbol.BELL, Symbol.BAR, Symbol.CHERRY, Symbol.BELL, Symbol.BAR, Symbol.BELL]

var slots_spinning: int = 0
var score: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("interact") and interact_area.get_overlapping_bodies().has(player):
		roll_slots()
	
	for slot in slots:
		if not slot.spinning:
			continue
		
		if not slot.timer_running and abs(slot.node.rotation.z - slot.target_rotation) < 0.1:
			slot.spinning = false
			slot.node.rotation.z = snappedf(slot.node.rotation.z, deg_to_rad(45))
			var symbol = rotation_to_symbol(slot.node.rotation.z)
			slot.symbol = symbol
			slots_spinning -= 1
			if slots_spinning <= 0:
				score += score_result()
				score_label.text = "Score: %s" % score
			continue
		
		slot.node.rotate_z(-0.03)
		slot.node.rotation.z = fposmod(slot.node.rotation.z, deg_to_rad(360))

func roll_slots():
	for slot in slots:
		slot.spinning = true
		slot.target_rotation = deg_to_rad(snappedf(randf()*360, 45))
		slot.timer_running = true
	
	slots_spinning = len(slots)
	
	await get_tree().create_timer(0.5).timeout
	
	for slot in slots:
		slot.timer_running = false

func rotation_to_symbol(rot: float) -> Symbol:
	# converts -45deg to 45deg
	var counter_rotation = deg_to_rad(360) - rot
	var index = posmod(roundi(counter_rotation / deg_to_rad(45)), len(symbol_list))
	return symbol_list[index]

func score_result() -> int:
	var symbol = slots[0].symbol
	for slot in slots:
		if slot.symbol != symbol:
			return 0
	
	return 100 if symbol == Symbol.SEVEN else 10
