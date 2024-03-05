extends Area3D

var time := 0.0
var grabbed := false
var fly := 0

# Collecting coins

func _on_body_entered(body):
	if !grabbed:
		grabbed = true
		
		Game.collect_coin()
		
		fly = 5.
		$SoundCoin.play()
		await $SoundCoin.finished
		queue_free() # Make invisible

# Rotating, animating up and down

func _process(delta):
	
	rotate_y(2 * delta) # Rotation
	position.y += (cos(time * 5) * 1) * delta # Sine movement

	position.y += fly * delta
	fly += fly * fly * delta
	
	time += delta
