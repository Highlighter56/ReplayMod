extends Node2D

# Gets the ammounds of all of the interactable parts
@onready var gates_count: int = %Folder_Gates.get_child_count()
@onready var switch_count: int = %Folder_Switches.get_child_count()
@onready var button_count: int = %Folder_Buttons.get_child_count()
# These counts will be used in for loops in the ready function to establish 
# how long to make the trigger/gate dictionaries. Once the part dicts 
# have been set up, we then go back in and set their connection arrays.

var gates = {
	"gate_1": {
		"connected_triggers": ["switch_1", "switch_2"],
		"current_state": false
	}
}

var triggers = {
	"switch_1": {
		"connected_gates": ["gate_1"],
		"is_active": false
	}
}

var buttons = {
	"button_1": {
		"connected_gates": ["gate_1"],
		"is_active": false
	}
}


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
