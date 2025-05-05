extends CharacterBody2D
# Platform UA

# For this, just make sure each platform_ua has a 
@onready var destination: Vector2 = $"../Destination".position
@onready var origin:Vector2 = position

@export var trigger:Node
var trigger_state:bool :
	get():
		return trigger.state

@export var speed:int = 200


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
#	If ON
	if trigger_state:
		#print("Trigger is On")
		if position != destination:
			velocity = (destination - position).normalized() *speed
		# Checking if Close Enough
			if abs(position.x - destination.x) < 5 and abs(position.y - destination.y) < 5:
				velocity=Vector2.ZERO
#	If OFF
	else:
		#print("Trigger is Off")
		if position != origin:
			velocity = (origin - position).normalized() *speed
		# Checking if Close Enough
			if abs(position.x - origin.x) < 5 and abs(position.y - origin.y) < 5:
				velocity=Vector2.ZERO

	#print(velocity)
	move_and_slide()
