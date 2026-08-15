extends Node3D

# local objects
@onready var interact_area: Area3D = $Interact
@onready var card_pile: Node3D = $CardPile

# global objects
@onready var player: Node3D = $"../Player"
@onready var score_label: Label = $"../CanvasGroup/ScoreLabel"
@onready var interact_label: Label = $CanvasGroup/InteractLabel
@onready var not_coded_label = $NotCodedLabel

const card = preload("res://Scenes/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_label.visible = false
	not_coded_label.visible = false
	
	#for i in range(52):
	var new_card = card.instantiate()
	card_pile.add_child(new_card)
	#new_card.position = Vector3(0, i * 0.001, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# 0 degrees is facing negative z
	var facing: Vector2 = Vector2(-sin(player.head.rotation.y), -cos(player.head.rotation.y))
	var direction: Vector3 = player.position.direction_to(position)
	var dot: float = facing.dot(Vector2(direction.x, direction.z))
	
	var is_interactable: bool = dot > 0 and interact_area.get_overlapping_bodies().has(player)
	not_coded_label.visible = is_interactable
	interact_label.visible = is_interactable
	
	if is_interactable and Input.is_action_just_pressed("interact"):
		pass
