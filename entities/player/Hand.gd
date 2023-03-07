extends Node3D

signal toggle_lighter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("toggle_light"):
		toggle_lighter.emit()
