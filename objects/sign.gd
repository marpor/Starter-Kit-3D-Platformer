extends Node3D

## Menu to show while the player is standing in front of the sign
# We're using a PackedScene here, in the previous examples (portals 
# and menu buttons) we used a file path. Using a PackedScene is 
# slightly nicer in many ways.
@export var menu_scene: PackedScene

# Keep track of whether we're already showing the menu or not
var menu: Node = null

# When something (likely the player) enters the Area3D node
func _on_area_3d_body_entered(body):
	# If we've got a menu selected and it's not already shown
	if menu_scene and not menu:
		# Instantiate the menu
		menu = menu_scene.instantiate()

		# Add it to the SceneTree on the root node
		get_node("/root").add_child(menu)

# When something (likely the player) exits the Area3D node
func _on_area_3d_body_exited(body):
	# Free (and thus hide) the menu again
	if is_instance_valid(menu):
		menu.queue_free()
