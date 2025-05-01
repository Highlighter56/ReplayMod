extends Area2D



@onready var game_manager: Node2D = %Game_Manager
@onready var face: MeshInstance2D = $Face
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var state:bool = false

@onready var range:int = collision_shape.shape.radius

func _ready() -> void:
	# Connect to game manager's signal
	%Game_Manager.interactable_trigger.connect(_on_game_manager_interactable_trigger)
	setColor()

func setColor():
	if state:
		face.modulate = Color("Green")
	else:
		face.modulate = Color("Red")


func _on_game_manager_interactable_trigger(origin: Vector2, is_being_pressed:bool) -> void:
	#print(is_being_pressed)
# If signal is within range
	if abs(position.distance_to(origin)) <= range:
		#print("Within Range")
	# If signaling pressed
		if is_being_pressed:
			state = true
	# If signaling released
		else:
			state = false
	# Sets color regardless if pressed or released
		setColor()


func _on_body_exited(body: Node2D) -> void:
	state = false
	setColor()
