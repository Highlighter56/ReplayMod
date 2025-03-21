extends CharacterBody2D



@onready var record_manager: Node2D = $".."


# Character Movment Properties
var SPEED = 200
var JUMP_VELOCITY = -300.0


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
func change_state(state:int):
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
		record_manager.actions.INTERACT:
			pass
	# End Replay
		record_manager.actions.END_REPLAY:
			toDefault()
	#printState()

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
func printState():
	print("----------")
	print("Jump: "+str(jump_now))
	print("Left: "+str(go_left))
	print("Right: "+str(go_right))
	print("----------")
