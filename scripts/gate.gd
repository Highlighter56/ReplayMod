extends Node2D

@onready var collider: CollisionShape2D = $CollisionShape2D

@export var trigger:Node
var trigger_state:bool :
	get():
		return trigger.state

@export var is_inverted:bool
# If NOT inverted: Gate is ON when switch is OFF
# If IS inverted:  Gate is OFF when switch is ON

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_inverted:
		if trigger_state:
			visible = true
			collider.disabled = false
		else:
			visible = false
			collider.disabled = true
	else:
		if trigger_state:
			visible = false
			collider.disabled = true
		else:
			visible = true
			collider.disabled = false
