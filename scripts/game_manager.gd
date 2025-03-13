extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var recorded_run: CharacterBody2D = $"../RecordedRun"
@onready var record_indicator: MeshInstance2D = $"../Record_Indicator"

var locations:Array = []			# Array to store player postiion
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
			locations.clear()
			record_indicator.modulate = Color("Green")
		else:
			record_indicator.modulate = Color("Red")
		print("Is Recording: "+str(isRecording))
	
#	Triggers Play Recording
# Note: With this system, one you start playing a recording, the 
# only way for it to stop is for the recording to finish
	if !playingRecording and Input.is_action_just_pressed("play"):
		if !locations.is_empty():
			if !isRecording:
				playingRecording = true
				recorded_run.position = locations[0]
				recorded_run.visible = true
			else:
				print("Recording is still in progress")
		else: 
			print("Nothing has been recorded")


func _physics_process(delta: float) -> void:
#	Records player position
	if isRecording:
		locations.append(player.position)
	
#	Plays Recording
	if playingRecording:
		print(locations[recordingIndex])
		recorded_run.position = locations[recordingIndex]
		recordingIndex+=1
#		If you have reached the end of the recording:
		if recordingIndex == locations.size()-1:
			print("Recording Finished")
			recordingIndex=0
			playingRecording=false
			recorded_run.visible = false
