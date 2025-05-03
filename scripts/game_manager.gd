extends Node2D

# This is the global timer that controls everything
var timer:float = 0
# Simple way to minimize lines of code that are needed whne pausing
var isPaused:bool = false:
	set(value):
		isPaused=value
		Engine.time_scale = 1
		if isPaused:
			Engine.time_scale = 0
#get_tree().paused = isPaused
# Godot has a built in pause function. When its true, it freezes/disables all
# nodes in the paused scene. If this function was placed into an auto load, 
# then this would work. With this set up, where the listenign function is 
# inside the scene that would be paused, there becomes no way to un-pause

# This is so I can adjust the attirbutes of the character in one
# place, rather than in 2 places
@export_group("Charater Attributes")
@export var speed:float = 200
@export var jump_velocity:float = -300

signal interaction_detected(origin:Vector2, is_being_pressed:bool)

func _ready() -> void:
	#print("Emitting switch")
	#switch.emit(Vector2.ZERO)
	pass

func _process(delta: float) -> void:
# Updates Timer
	timer = timer + delta
	
#	Reset
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
# Pause
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
	#	Controller Unpause work around - it looks like your clicking 'Resume'
	if isPaused and Input.is_action_just_pressed("interact"):
		isPaused = false



# From here, a signal will be emitted to all switches. If the specified
# origin is within the switches range, it will switch state.
func _on_interaction_requested(origin: Vector2, is_being_pressed:bool) -> void:
	print(is_being_pressed,": Is Interacting")
	if is_being_pressed:
		interaction_detected.emit(origin, true)
	else:
		interaction_detected.emit(origin, false)
