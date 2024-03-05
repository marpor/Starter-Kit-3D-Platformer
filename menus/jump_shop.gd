extends Control

func _on_back_button_pressed():
	get_tree().paused = false
	queue_free()


func _on_double_button_pressed():
	if Game.coins >= 5:
		Game.buy(5)
		Game.jump_max += 1
		queue_free()
		


func _on_triple_button_pressed():
	pass # Replace with function body.


func _on_quad_button_pressed():
	pass # Replace with function body.
