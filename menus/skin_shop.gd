extends Control

func _on_back_button_pressed():
	get_tree().paused = false
	queue_free()


func _on_double_button_pressed():
	if Game.coins >= 5:
		Game.coins = Game.coins - 5
		# buy


func _on_triple_button_pressed():
	pass # Replace with function body.


func _on_quad_button_pressed():
	pass # Replace with function body.
