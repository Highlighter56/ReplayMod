extends Area2D



@onready var face: MeshInstance2D = $Face
@onready var range:int = $CollisionShape2D.shape.radius

@export var state:bool = false


func _ready() -> void:
	# Connect to game manager's signal
	%Game_Manager.interaction_detected.connect(_on_game_manager_interaction_detected)
	self.body_exited.connect(_on_body_exited)
	setColor()

func setColor():
	if state:
		face.modulate = Color("Green")
	else:
		face.modulate = Color("Red")


func _on_game_manager_interaction_detected(origin: Vector2, is_being_pressed:bool) -> void:
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
