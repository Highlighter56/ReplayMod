extends Node2D

# This is the global timer that controls everything
var timer:float = 0

# This is so I can adjust the attirbutes of the character in one
# place, rather than in 2 places
@export_group("Charater Attributes","")
@export var speed:float = 200
@export var jump_velocity:float = -300

signal interactable_trigger(origin:Vector2, is_being_pressed:bool)

func _ready() -> void:
	#print("Emitting switch")
	#switch.emit(Vector2.ZERO)
	pass

func _process(delta: float) -> void:
# Updates Timer
	timer = timer + delta
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


# From here, a signal will be emitted to all switches. If the specified
# origin is within the switches range, it will switch state.
func _on_interact(origin: Vector2, is_being_pressed:bool) -> void:
	print(is_being_pressed,": Is Interacting")
	if is_being_pressed:
		interactable_trigger.emit(origin, true)
	else:
		interactable_trigger.emit(origin, false)
