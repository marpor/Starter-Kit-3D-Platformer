extends RigidBody3D

signal coin_collected

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 50

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

var coins = 0

@onready var particles_trail = $ParticlesTrail
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer
@onready var sound_footsteps = $SoundFootsteps

# Functions

func _physics_process(delta):
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	handle_effects()
	
	# Movement

	var applied_velocity: Vector3
	
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity
#	floor_snap_length = 30.0
	move_and_slide()
#	velocity = get_platform_velocity()
	
	# Rotation
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()
		
	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)
	
	# Falling/respawning
	
	if position.y < -10:
		get_tree().reload_current_scene()
	
	# Animation for scale (jumping and landing)
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)
	
	# Animation when landing
	
	if is_on_floor(): # and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		$SoundLand.play()
	
	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects():
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)

# Handle movement input

func handle_controls(delta):
	
	# Movement
	
	var input := Vector3.ZERO
	
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	input = input.rotated(Vector3.UP, view.rotation.y).normalized()
	
	movement_velocity = input * movement_speed * delta
	
	# Jumping

	if Input.is_action_just_pressed("jump"):
		
		if jump_double:
			jump_double = false
			jump()

		if jump_single:
			jump_single = false
			jump_double = true
			jump()

# Handle gravity

func handle_gravity(delta):
	
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		jump_single = true
		gravity = 0

# Jumping

func jump():
#	velocity += get_platform_velocity()
	gravity = -sqrt(jump_strength)
	model.scale = Vector3(0.5, 1.5, 0.5)
	$SoundJump.play()
