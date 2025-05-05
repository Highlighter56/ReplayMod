extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var camera: Camera2D = %Camera2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("load_level2"):
		camera.position.y = 300
		player.position = Vector2(-194, 385)
	if Input.is_action_just_pressed("load_level1"):
		camera.position.y = -300
		player.position = Vector2(-135, -225)
