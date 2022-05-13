extends Sprite

export(int, 1, 10) var fuel : int = 3
var original_fuel

export var fuel_time : float = 1.0

var player = null

var state_3 = preload("res://Assets/Sprites/Fire_3.png")
var state_2 = preload("res://Assets/Sprites/Fire_2.png")
var state_1 = preload("res://Assets/Sprites/Fire_1.png")
var state_0 = preload("res://Assets/Sprites/Fire_0.png")


func _ready():
	$CPUParticles2D.emitting = true
	texture = state_3
	original_fuel = fuel


func _process(_delta):
	if player == null:
		return
	if $Fuel_timer.time_left != 0:
		return
	
	$Fuel_timer.start(fuel_time)


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		player = body


func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		player = null


func _on_Transfer_timer_timeout():
	add_fuel()


func add_fuel():
	if player == null:
		return
	if player.fuel == player.max_fuel:
		return
	
	Sounds.play_sound("campfire_recharge")
	
	player.add_fuel(1)
	reduce_and_check_fuel(1)
	check_state()


func reduce_and_check_fuel(amount):
	if fuel - amount <= 0:
		for i in self.get_children():
			i.queue_free()
	fuel -= amount
	print("Fuel regained: " + str(amount))


func check_state():
	var state = float(fuel) / float(original_fuel)
	
	if fuel < original_fuel * 1/3 or fuel == 0:
		texture = state_0
	elif fuel >= original_fuel * 1/3 and fuel < original_fuel * 2/3:
		texture = state_1
	elif fuel >= original_fuel * 2/3:
		texture = state_2
