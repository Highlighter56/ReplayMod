extends Node2D

# This is the global timer that controls everything
var timer:float = 0

# This is so I can adjust the attirbutes of the character in one
# place, rather than in 2 places
@export_group("Charater Attributes","")
@export var speed:float = 200
@export var jump_velocity:float = -300


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	timer = timer + delta
	
	#if Input.is_action_just_pressed("jump"):
		#print(Input.is_action_pressed("move_left"))
		#print(Input.is_action_pressed("move_right"))


func _on_interact(origin: Vector2) -> void:
	print("Game Manager Recieved Interact Signal",origin)
