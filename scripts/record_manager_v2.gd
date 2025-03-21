extends Node2D
# V2

# References
@onready var player: CharacterBody2D = %Player
@onready var record_indicator: MeshInstance2D = $Record_Indicator
@onready var recorded_run: CharacterBody2D = $Recorded_Run
# This is set like this to make an easy way to grab the 
# global timers updated value
@onready var global_timer: float = 0:
	get():
		return $"../Game_Manager".timer

# An Array of Vector2's
# inputs.x = time  inputs.y = action
var recorded_inputs:Array = []
# This enum will be used to note which action occured
enum actions 	{JUMP_PRESSED, LEFT_PRESSED, LEFT_RELEASED, RIGHT_PRESSED, 
				RIGHT_RELEASED}

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
	#recorded_run.visible = false
	pass

func _process(delta: float) -> void:
#	Triggers Start/Stop Recording
	if Input.is_action_just_pressed("record"):
		isRecording = !isRecording
		if isRecording:
			recorded_inputs.clear()
			recorded_inputs.append(player.position) # This is becasue the first index in the array is noted as the starting location
			recordingIndex = 1
			recording_start_time = global_timer
			record_indicator.modulate = Color("Green")
		else:
			record_indicator.modulate = Color("Red")
	
#	Triggers Play Recording
# Note: With this system, once you start playing a recording, the 
# only way for it to stop is for the recording to finish
	if !playingRecording and Input.is_action_just_pressed("play"):
		if recorded_inputs.size() > 1:
			if !isRecording:
				print("Playign Recording")
				playingRecording = true
				recorded_run.position = recorded_inputs[0]
				playback_start_time = global_timer
				recorded_run.visible = true
				print("Is Visible")
			else:
				print("Recording is still in progress")
		else: 
			print("Nothing has been recorded")
	
	
#	-----Recording-----
	if isRecording:
	# Jump
		if Input.is_action_just_pressed("jump"):
			recorded_inputs.append(Vector2(recording_time_elapsed, actions.JUMP_PRESSED))
			#print("Pressed Jump", global_timer)
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

func _physics_process(delta: float) -> void:

#	-----Plays Recording-----

#	Tracking/Updating recordingIndex to determine when inputs are received
	if playingRecording:
		if playback_time_elapsed >= recorded_inputs[recordingIndex].x:
			recorded_run.change_state(recorded_inputs[recordingIndex].y)
			recordingIndex+=1
#		--When Recording Finished--
#		if at end of array
		if recordingIndex == recorded_inputs.size():
			print("Recording Finished")
			recorded_run.toDefault()
			playingRecording=false
#			Theres a problem where if the player ends a recording in mid air, that the recording now hangs in the air for a second before disapearing. Perhaps in the real build I can have the hollogram freeze in space, and then instead of popping away instantly, have it fade out. This might make the hanging look more realistic/fair
			await get_tree().create_timer(.5).timeout
			recorded_run.visible = false
	
#	Based on determined inputs, playing the recorded run
