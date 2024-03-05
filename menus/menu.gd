extends Control

@export_file("*.tscn") var start_scene: String
@export_file("*.tscn") var skin_scene: String

func _on_button_pressed():
	get_tree().change_scene_to_file(start_scene)

func _on_skin_button_pressed():
	get_tree().change_scene_to_file(skin_scene)
