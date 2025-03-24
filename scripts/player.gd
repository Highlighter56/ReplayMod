extends CharacterBody2D


@onready var game_manager: Node2D = %Game_Manager


# Character Movment Properties
@onready var SPEED:float = game_manager.speed
@onready var JUMP_VELOCITY:float = game_manager.jump_velocity

#Interaction Signal
signal interact(origin:Vector2)


func _ready() -> void:
	pass

func _process(delta: float) -> void:
# Emits interaction signal when pressed
	if Input.is_action_just_pressed("interact"):
		#print("Player is Interacting")
		emit_signal("interact",position)

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	# Note: Changing is_action_just_pressed to is_aciton_pressed changes
	# jumping from press to jump, to hold to jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
