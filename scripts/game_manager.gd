extends Node2D

# This is the global timer that controls everything
var timer:float = 0

# This is so I can adjust the attirbutes of the character in one
# place, rather than in 2 places
@export_group("Charater Attributes")
@export var speed:float = 200
@export var jump_velocity:float = -300

# Interacting
signal interaction_detected(origin:Vector2, is_being_pressed:bool)

# Pausing
@onready var pause_menu: CanvasLayer = %PauseMenu
# Simple way to minimize lines of code that are needed whne pausing
var isPaused:bool = false:
	set(value):
		isPaused=value
		if isPaused:
			Engine.time_scale = 0
			pause_menu.visible = true
		else:
			Engine.time_scale = 1
			pause_menu.visible = false
#get_tree().paused = isPaused
# Godot has a built in pause function. When its true, it freezes/disables all
# nodes in the paused scene. If this function was placed into an auto load, 
# then this would work. With this set up, where the listenign function is 
# inside the scene that would be paused, there becomes no way to un-pause

@onready var continue_button: Button = $"../PauseMenu/CenterContainer/PanelContainer/VBoxContainer/Continue_Button"


@onready var star: Area2D = $Star
var star_picked_up:bool = false

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

func _process(delta: float) -> void:
# Updates Timer
	timer = timer + delta
	
# Reset
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
# Pause
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
	#	Controller Unpause work around - it looks like your clicking 'Resume'
	if isPaused and Input.is_action_just_pressed("interact"):
		isPaused = false

func _physics_process(delta: float) -> void:
# Rotating the Star
	if !star_picked_up:
		star.rotate((PI/60)/4)


# From here, a signal will be emitted to all switches. If the specified
# origin is within the switches range, it will switch state.
func _on_interaction_requested(origin: Vector2, is_being_pressed:bool) -> void:
	#print(is_being_pressed,": Is Interacting")
	if is_being_pressed:
		interaction_detected.emit(origin, true)
	else:
		interaction_detected.emit(origin, false)

func _on_continue_button_pressed():
	isPaused = !isPaused


func _on_star_body_entered(body: Node2D) -> void:
	star_picked_up=true
	star.queue_free()
