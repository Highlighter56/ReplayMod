extends Area2D



@onready var game_manager: Node2D = %Game_Manager
@onready var face: MeshInstance2D = $Face

@export var state:bool = false


func _ready() -> void:
# Im not sure why this doesnt work
# Connects the Game Manager to the Switch
	#game_manager.switch.connect(_on_switch)
	pass
# Setting Initial Color
	setColor()

func _on_switch(origin:Vector2):
	#print("Switch Signal Received")
	#print(origin, position, abs(position.distance_to(origin)))
	if abs(position.distance_to(origin)) <= 24:
		state = !state
		setColor()
	#receiver.trigger(state)

func setColor():
	if state:
		face.modulate = Color("Green")
	else:
		face.modulate = Color("Red")
