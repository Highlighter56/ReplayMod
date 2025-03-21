extends CharacterBody2D


var SPEED = 200
var JUMP_VELOCITY = -300.0

@onready var record_manager: Node2D = $".."

# Used as parameters to contorl the recorded run
var jump_now:bool = false
var go_left:bool = false
var go_right:bool = false


func _ready() -> void:
	
	#print(record_manager.actions.JUMP_PRESSED)
	#print(record_manager.actions.LEFT_PRESSED)
	#print(record_manager.actions.LEFT_RELEASED)
	#print(record_manager.actions.RIGHT_PRESSED)
	#print(record_manager.actions.RIGHT_RELEASED)
	pass

func _physics_process(delta: float) -> void:
	if record_manager.playingRecording:
		#print("Should be Playing")
		
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if shouldJump() and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		var direction := get_axis(go_left, go_right)
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		#print(velocity)
		move_and_slide()

# Sets the parameters: jump_now, go_left, and go_right
func change_state(state:int):
	#print(state)
	match state:
		record_manager.actions.JUMP_PRESSED:
			#print("Jump Now")
			jump_now=true
		record_manager.actions.LEFT_PRESSED:
			#print("Go Left")
			go_left=true
		record_manager.actions.LEFT_RELEASED:
			#print("Stop Left")
			go_left=false
		record_manager.actions.RIGHT_PRESSED:
			#print("Go Right")
			go_right=true
		record_manager.actions.RIGHT_RELEASED:
			#print("Stop Right")
			go_right=false
	#printState()

# Replaces the get_axis function that takes in 
# two input actions
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

# When a recording is done, this sets resets the rigid body
func toDefault():
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
