extends Node2D


var timer:float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	timer = timer + delta
