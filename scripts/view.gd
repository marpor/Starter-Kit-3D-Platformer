extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Zoom")
@export var zoom_minimum = 16
@export var zoom_maximum = 4
@export var zoom_speed = 10

@export_group("Rotation")
@export var rotation_speed = 120

var camera_rotation:Vector3
var zoom = 10

@onready var camera = $Camera

func _init():
	camera_rotation = rotation_degrees # Initial rotation
	camera_rotation.x = -25
	# Initialize the camera to look up
	rotation_degrees.x = 25

#	var refresh_rate = DisplayServer.screen_get_refresh_rate()
#	print("refresh_rate", refresh_rate)
#	Engine.max_fps = refresh_rate
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _ready():
	
	position = target.position
	position.y -= 5
	
	# Start the animation to move the camera to look down smoothly
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "rotation_degrees:x", camera_rotation.x, 1.5).from_current()

func pan_out():
	# Start the animation to move the camera to look up smoothly
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rotation_degrees:x", 25, .5).from_current()

func _physics_process(delta):
	
	# Set position and rotation to targets
	
	self.position = self.position.lerp(target.position+Vector3(0,1,0), delta * 4)
	rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	
	camera.position = camera.position.lerp(Vector3(0, 0, zoom), 8 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	# Zooming
	
	zoom += Input.get_axis("zoom_in", "zoom_out") * zoom_speed * delta
	zoom = clamp(zoom, zoom_maximum, zoom_minimum)
	
func _input(event):
	
	# Toggle fullsreen
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F:
			# Check the current window mode and toggle between fullscreen and windowed.
			var current_mode = DisplayServer.window_get_mode()
			if current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_flag_captured():
	pan_out()
