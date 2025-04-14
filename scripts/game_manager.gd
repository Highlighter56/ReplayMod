extends Node2D

# This is the global timer that controls everything
var timer:float = 0

# This is so I can adjust the attirbutes of the character in one
# place, rather than in 2 places
@export_group("Charater Attributes","")
@export var speed:float = 200
@export var jump_velocity:float = -300

signal switch(origin:Vector2)

func _ready() -> void:
	#print("Emitting switch")
	#switch.emit(Vector2.ZERO)
	pass

func _process(delta: float) -> void:
	timer = timer + delta
	
	#if Input.is_action_just_pressed("jump"):
		#print(Input.is_action_pressed("move_left"))
		#print(Input.is_action_pressed("move_right"))


# From here, a signal will be emitted to all switches. If the specified
# origin is within the switches range, it will switch state.
func _on_interact(origin: Vector2) -> void:
	#print("Game Manager Recieved Interact Signal",origin)
	switch.emit(origin)
