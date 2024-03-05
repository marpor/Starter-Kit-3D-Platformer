extends Button

@export_file("*.tscn") var scene: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file(scene)
