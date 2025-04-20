extends CharacterBody2D


@onready var game_manager: Node2D = %Game_Manager
@onready var record_manager: Node2D = %Record_Manager


# Character Movment Properties
@onready var SPEED:float = game_manager.speed
@onready var JUMP_VELOCITY:float = game_manager.jump_velocity

# Used as parameters to contorl the recorded run
var jump_now:bool = false
var go_left:bool = false
var go_right:bool = false

# Keeps track of Initial Conditions
var initial_velocity:Vector2
var initial_position:Vector2
# Used if when the recording starts, left or right are already being
# pressed, this will set go_left and go_right to true by default
# 0=no initial left/right; 1=initial left; 2=initial right; 3=initial left and right
var initial_left_right:int = 0

#Interaction Signal
signal interact(origin:Vector2, is_being_pressed:bool)


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
#	Moves the Character / Plays the recording
	if record_manager.playingRecording:
		#print("Should be Playing")
		
		# Add the gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump
		if shouldJump() and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration
		var direction := get_axis(go_left, go_right)
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		#print(velocity)
		move_and_slide()



# Sets the control parameters: jump_now, go_left, and go_right
func update_state(state:int):
	#print(state)
	match state:
	# Start Replay / Initial Conditions
		record_manager.actions.START_REPLAY:
			setInitialConditions()
	# Left
		record_manager.actions.LEFT_PRESSED:
			#print("Go Left")
			go_left=true
		record_manager.actions.LEFT_RELEASED:
			#print("Stop Left")
			go_left=false
	# Right
		record_manager.actions.RIGHT_PRESSED:
			#print("Go Right")
			go_right=true
		record_manager.actions.RIGHT_RELEASED:
			#print("Stop Right")
			go_right=false
	# Jump
		record_manager.actions.JUMP_PRESSED:
			#print("Jump Now")
			jump_now=true
	# Interact
		record_manager.actions.INTERACT_PRESSED:
			#print("Replay is Interacting")
			emit_signal("interact",position, true)
		record_manager.actions.INTERACT_RELEASED:
			#print("Replay is Interacting")
			emit_signal("interact",position, false)
	# End Replay
		record_manager.actions.END_REPLAY:
			toDefault()
	#printState(state)

# Replaces the get_axis function that takes
# in two input actions
func get_axis(negative_condition:bool, positive_condition:bool)->int:
	if negative_condition and !positive_condition:
		return -1
	if !negative_condition and positive_condition:
		return 1
	return 0

# Replaces the call to check if the jump input was just entered
func shouldJump()->bool:
	if jump_now:
		jump_now=false
		return true
	return false

# When recording starts, sets initial state
func setInitialConditions():
	position=initial_position
	velocity=initial_velocity
# Used if/when left/right are pressed before the recording starts
	match initial_left_right:
	# No initial left/right
		0:
			pass
	# initial left pressed
		1:
			go_left=true
	# initial right pressed
		2:
			go_right=true
	# initial left and right pressed
		3:
			go_left=true
			go_right=true
# The Last initial condition to be set is visibility
	visible = true

# When a recording is done, this sets resets the rigid body
func toDefault():
	visible = false
	jump_now=false
	go_left=false
	go_right=false

# Used for Debuging
func printState(state:int):
	print("----------")
# This print line prints out the Key associated with the enum value
# The keys() method is meant to be used on dictionaries. The output
# is an array just the keys for that given dictionary. It appears that
# this method also works on enums. In this case, state is acting as 
# ths index of the key that we are looking to identify
	print(record_manager.actions.keys()[state])
	print("Jump: "+str(jump_now))
	print("Left: "+str(go_left))
	print("Right: "+str(go_right))
	print("----------")
