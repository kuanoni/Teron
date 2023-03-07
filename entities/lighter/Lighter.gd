extends Node3D

@export var starts_open := false
@export_node_path("AnimationPlayer") var animation_player_path := NodePath("AnimationPlayer")
@onready var animation_player: AnimationPlayer = get_node(animation_player_path)

var open_animation_key = "open_lighter"
@onready var open_animation_length: float = animation_player.get_animation(open_animation_key).length
@onready var is_open := starts_open

# Called when the node enters the scene tree for the first time.
func _ready():
	if (starts_open):
		animation_player.play("open_lighter")
		animation_player.advance(open_animation_length)
	else:
		animation_player.play_backwards("open_lighter")
		animation_player.advance(open_animation_length)

func _on_animation_finished(anim_name):
	animation_player.stop(true)

func _on_hand_toggle_lighter():
	if is_open:
		animation_player.play_backwards("open_lighter")
	else:
		animation_player.play("open_lighter")
	
	is_open = !is_open
	
