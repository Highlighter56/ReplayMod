extends Area2D



@onready var game_manager: Node2D = %Game_Manager
@onready var face: MeshInstance2D = $Face
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var state:bool = false

@onready var range:int = collision_shape.shape.radius

func _ready() -> void:
# Setting Initial Color
	setColor()
	#print(collision_shape.shape.radius)
	

func _on_switch(origin:Vector2):
	#print("Switch Signal Received")
	#print(origin, position, abs(position.distance_to(origin)))
	if abs(position.distance_to(origin)) <= range:
		state = !state
		setColor()
	#receiver.trigger(state)

func setColor():
	if state:
		face.modulate = Color("Green")
	else:
		face.modulate = Color("Red")
