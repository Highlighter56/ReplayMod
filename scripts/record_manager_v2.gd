extends Node2D
# V2

# References
@onready var player: CharacterBody2D = %Player
@onready var record_indicator: MeshInstance2D = $Record_Indicator
@onready var recorded_run: CharacterBody2D = $Recorded_Run
@onready var global_timer: float = 0:
	get():
		return $"../Game_Manager".timer

# An Array of Vector2's
# inputs.x = time  inputs.y = action
var recorded_inputs:Array = []
# This enum will be used to note which action occured
enum actions 	{LEFT_PRESSED, LEFT_RELEASED, RIGHT_PRESSED, 
				RIGHT_RELEASED, JUMP_PRESSED}

# ---Time Trackers---
# When recording Starts, this tracks the time
var recording_start_time:float
# Tracks the local recording time
var recording_time_elalsed:float :
	get():
		return global_timer-recording_start_time

# When playback starts, this tracks the time
var playback_start_time:float
# Tracks the local playback time
var playback_time_elalsed:float :
	get():
		return global_timer-playback_start_time

var recordingIndex:int = 0		# Index to loop through recording
var isRecording:bool = false		# Notes when to be recording
var playingRecording:bool = false	# Notes when to play recording

func _ready() -> void:
	recorded_run.visible = false


func _process(delta: float) -> void:
#	Triggers Start/Stop Recording
	if Input.is_action_just_pressed("record"):
		isRecording = !isRecording
		if isRecording:
			recorded_inputs.clear()
			recorded_inputs.append(player.position)
			recordingIndex = 1
			recording_start_time = global_timer
			record_indicator.modulate = Color("Green")
		else:
			record_indicator.modulate = Color("Red")
	
#	Triggers Play Recording
# Note: With this system, once you start playing a recording, the 
# only way for it to stop is for the recording to finish
	if !playingRecording and Input.is_action_just_pressed("play"):
		if !recorded_inputs.is_empty():
			if !isRecording:
				print("Recording Started")
				playingRecording = true
				recorded_run.position = recorded_inputs[0]
				playback_start_time = global_timer
				recorded_run.visible = true
				print(recorded_inputs.size())
			else:
				print("Recording is still in progress")
		else: 
			print("Nothing has been recorded")
	
	
#	-----Recording-----
	if isRecording:
	# Left
		if Input.is_action_just_pressed("move_left"):
			recorded_inputs.append(Vector2(actions.LEFT_PRESSED, recording_time_elalsed))
			#print("Pressed Left", global_timer)
		if Input.is_action_just_released("move_left"):
			recorded_inputs.append(Vector2(actions.LEFT_RELEASED, recording_time_elalsed))
			#print("Released Left", global_timer)
	# Right
		if Input.is_action_just_pressed("move_right"):
			recorded_inputs.append(Vector2(actions.RIGHT_PRESSED, recording_time_elalsed))
			#print("Pressed Right", global_timer)
		if Input.is_action_just_released("move_right"):
			recorded_inputs.append(Vector2(actions.RIGHT_RELEASED, recording_time_elalsed))
			#print("Released Right", global_timer)
	# Jump
		if Input.is_action_just_pressed("jump"):
			recorded_inputs.append(Vector2(actions.JUMP_PRESSED, recording_time_elalsed))
			#print("Pressed Jump", global_timer)

func _physics_process(delta: float) -> void:
	
#	Plays Recording
	if playingRecording:
		print(recordingIndex,recorded_inputs[recordingIndex])
		if playback_time_elalsed > recorded_inputs[recordingIndex].y:
			recordingIndex+=1
		
#		--When Recording Finished--
#		if at end of array
		if recordingIndex == recorded_inputs.size():
#			if recording duration is over
			#if playback_time_elalsed > recorded_inputs[recordingIndex].y:
				print("Recording Finished")
				playingRecording=false
	#			Theres a problem where if the player ends a recording in mid air, that the recording now hangs in the air for a second  before disapearing. Perhaps in the real build I can have the  hollogram freeze in space, and then instead of popping awayinstantly, have it fade out. This might make the hanging look more managable
				await get_tree().create_timer(.5).timeout
				recorded_run.visible = false
