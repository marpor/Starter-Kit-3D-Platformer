extends Node

var jump_max = 1 # Max allowed jumps

var coins := 0

func _ready():
	#%Music.play()
	#collect_coin()
	pass

# Collecting coins

func collect_coin():
	coins += 1
	update()

func buy(amount):
	coins -= amount
	update()
	
func update():
	%Coins.text = str(coins)
