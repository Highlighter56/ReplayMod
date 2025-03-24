extends Node2D

@onready var collider: CollisionShape2D = $CollisionShape2D

@export var trigger:Node
@export var state:bool = false:
	get():
		return !trigger.state

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if state:
		visible = true
		collider.disabled = false
	else:
		visible = false
		collider.disabled = true
