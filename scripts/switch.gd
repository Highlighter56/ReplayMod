extends Area2D



@onready var face: MeshInstance2D = $Face
@onready var range:int = $CollisionShape2D.shape.radius

@export var state:bool = false


func _ready() -> void:
	# Connect to game manager's signal
	%Game_Manager.interaction_detected.connect(_on_game_manager_interaction_detected)
	setColor()
	#print(collision_shape.shape.radius)


func setColor():
	if state:
		face.modulate = Color("Green")
	else:
		face.modulate = Color("Red")


func _on_game_manager_interaction_detected(origin: Vector2, is_being_pressed:bool) -> void:
	#print(is_being_pressed)
	#print("Switch Signal Received")
	#print(origin, position, abs(position.distance_to(origin)))
	if is_being_pressed:
		if abs(position.distance_to(origin)) <= range:
			state = !state
			setColor()
	#receiver.trigger(state)
