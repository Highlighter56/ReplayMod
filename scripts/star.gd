extends Area2D


var collected:bool = false


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
# Rotating the Star
	if !collected:
		rotate((PI/60)/4)


func _on_body_entered(body: Node2D) -> void:
	collected=true
	queue_free()
