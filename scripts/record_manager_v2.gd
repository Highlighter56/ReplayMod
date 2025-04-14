extends Node2D
# V2 - Macro System

# References
@onready var player: CharacterBody2D = %Player
@onready var record_indicator: MeshInstance2D = $CanvasLayer/Record_Indicator
@onready var recorded_run: CharacterBody2D = $Recorded_Run
# This is set like this to make an easy way to grab the 
# global timers updated value
@onready var global_timer: float = 0:
	get():
		return %Game_Manager.timer

# An Array of Vector2's
# inputs.x = time  inputs.y = action
var recorded_inputs:Array = []
# This enum will be used to note which action occured
enum actions {START_REPLAY, LEFT_PRESSED, LEFT_RELEASED, RIGHT_PRESSED, 
			  RIGHT_RELEASED, JUMP_PRESSED, INTERACT, END_REPLAY}

# ---Time Trackers---
# When recording Starts, this tracks the time
var recording_start_time:float
# Tracks time elapsed while recording
var recording_time_elapsed:float :
	get():
		return global_timer-recording_start_time
# When playback starts, this tracks the time
var playback_start_time:float
# Tracks the time elepased while playback-ing
var playback_time_elapsed:float :
	get():
		return global_timer-playback_start_time

var recordingIndex:int = 0:		# Index to loop through recording
	set(value):
#		These print statment are used when debugging
		#print("---")
		#print("Recording Index: "+str(recordingIndex))
		#print("Playback Time Elapsed: "+str(playback_time_elapsed))
		#print("Action: "+str(recorded_inputs[recordingIndex].y))
		#print("---")
		recordingIndex=value
var isRecording:bool = false		# Notes when to be recording
var playingRecording:bool = false	# Notes recording when recording is playing / when to start recording

func _ready() -> void:
	pass

func _process(delta: float) -> void:	
#	Triggers Start/Stop Recording
	if !playingRecording and Input.is_action_just_pressed("record"):
		isRecording = !isRecording
	# If Recording
		if isRecording:
			recording_start_time = global_timer
			recorded_inputs.clear()
			recordingIndex = 0
		# Sends initial velocity and position to recorded_run
			recorded_run.initial_position = player.position
			recorded_run.initial_velocity = player.velocity
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.START_REPLAY))
		# Checks if already pressing Left or Right
		# if neither left or right are being pressed
			if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
				recorded_run.initial_left_right=0
				#print("initial_left_right is 0")
		# if only left is being pressed
			elif Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
				recorded_run.initial_left_right=1
				#print("initial_left_right is 1")
		# if only right is being pressed
			elif !Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
				recorded_run.initial_left_right=2
				#print("initial_left_right is 2")
		# if both are being pressed
			else:
				recorded_run.initial_left_right=3
				#print("initial_left_right is 3")
				
			record_indicator.modulate = Color("Green")
	# If Stopped Recording
		else:
#			This is to ensure that the recording lasts until the 
#			recording process is stopped, not until the last input is entered
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.END_REPLAY))
			record_indicator.modulate = Color("Red")
	
#	Triggers Play Recording
# Note: With this system, once you start playing a recording, the 
# only way for it to stop is for the recording to finish
	if !playingRecording and Input.is_action_just_pressed("play"):
		if !recorded_inputs.is_empty():
			if !isRecording:
				print("Playign Recording")
				playback_start_time = global_timer
				playingRecording = true
				recordingIndex = 0
				#print("Is Visible")
			else:
				print("Recording is still in progress")
		else: 
			print("Nothing has been recorded")
	
# Recording / Taking in Inputs
	if isRecording:
	# Left
		if Input.is_action_just_pressed("move_left"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.LEFT_PRESSED))
			#print("Pressed Left", global_timer)
		if Input.is_action_just_released("move_left"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.LEFT_RELEASED))
			#print("Released Left", global_timer)
	# Right
		if Input.is_action_just_pressed("move_right"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.RIGHT_PRESSED))
			#print("Pressed Right", global_timer)
		if Input.is_action_just_released("move_right"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.RIGHT_RELEASED))
			#print("Released Right", global_timer)
	# Jump
		if Input.is_action_just_pressed("jump"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.JUMP_PRESSED))
			#print("Pressed Jump", global_timer)
	# Interact
		if Input.is_action_just_pressed("interact"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.INTERACT))
			#print("Pressed Interact", global_timer)
	
#	-----Plays Recording-----
#	Tracking/Updating recordingIndex to determine when inputs are received
	if playingRecording:
		if playback_time_elapsed >= recorded_inputs[recordingIndex].x:
			recorded_run.update_state(recorded_inputs[recordingIndex].y)
			recordingIndex+=1
#		--When Recording Finished--
#		if at end of array
		if recordingIndex == recorded_inputs.size():
			print("Recording Finished")
			playingRecording=false
#			Theres a problem where if the player ends a recording in mid air, that the recording now hangs in the air for a second before disapearing. Perhaps in the real build I can have the hollogram freeze in space, and then instead of popping away instantly, have it fade out. This might make the hanging look more realistic/fair
			#await get_tree().create_timer(.5).timeout

func _physics_process(delta: float) -> void:
	pass
