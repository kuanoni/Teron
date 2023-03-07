extends CharacterBody3D
class_name MovementController

@export_node_path("Node3D") var head_path := NodePath("Head")
@onready var head: Node3D = get_node(head_path)
@export_node_path("AnimationPlayer") var head_bob_animation_player_path := NodePath("HeadBobAnimationPlayer")
@onready var head_bob_animation_player: AnimationPlayer = get_node(head_bob_animation_player_path)

@export var gravity_multiplier := 3.0
@export var speed := 5
@export var acceleration := 8
@export var deceleration := 10
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10

var direction := Vector3()
var input_axis := Vector2()
# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") 
		* gravity_multiplier)

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	input_axis = Input.get_vector(&"move_back", &"move_forward",
			&"move_left", &"move_right")
	
	direction_input()
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	
	accelerate(delta)
	
	move_and_slide()
	
	head_bob()


func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y


func accelerate(delta: float) -> void:
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

func head_bob() -> void:
	head_bob_animation_player.speed_scale = speed
	
	if direction != Vector3():
		head_bob_animation_player.play("player_head_bob")
	else:
		head_bob_animation_player.speed_scale = speed * 2
