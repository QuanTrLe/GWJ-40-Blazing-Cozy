extends KinematicBody2D

signal fuel_changed

export var move_speed = 250
var velocity := Vector2()

export var jump_height : float
export var jump_time_to_peak : float
export var jump_time_to_descent : float

onready var jump_velocity : float = ((2.0 * jump_height) / \
	jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / \
	(jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / \
	(jump_time_to_descent * jump_time_to_descent)) * -1.0

export var fuel : int = 3
export var max_fuel : int = 3
var can_blaze = true
var blaze_time = 0.05

var blaze_radius := 112
export var Blaze_emission: PackedScene


func _ready():
	$Blaze/CollisionShape2D.shape.radius = blaze_radius
	$AnimationTree.active = true


func _process(_delta):
	#Blaze
	if Input.is_action_just_pressed("blaze") and can_blaze:
		if !check_empty_fuel():
			return
		add_fuel(-1)
		
		Sounds.play_sound("player_blaze")
		
		$Blaze.monitoring = true
		can_blaze = false
		
		$Blaze_timer.start(blaze_time)
		$AnimationTree.set("parameters/Blazing/active", true)


func _physics_process(delta):
	#Move
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		Sounds.play_sound("player_jump")
		jump()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#Animate
	if velocity.x != 0 and velocity.y == 0:
		$AnimationTree.set("parameters/Walking/blend_amount", 1)
	else:
		$AnimationTree.set("parameters/Walking/blend_amount", 0)
	
	if velocity.x > 0:
		$Sprite.flip_h = false
		$CollisionShape2D.scale.x = 1
	elif velocity.x < 0:
		$Sprite.flip_h = true
		$CollisionShape2D.scale.x = -1


func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func jump():
	velocity.y = jump_velocity


func get_input_velocity() -> float:
	var horizontal := 0.0
	
	horizontal = Input.get_action_strength("right") \
		- Input.get_action_strength("left")
	
	return horizontal


func _on_Blaze_body_entered(body): #Melt object
	if body == self: return
	if body.is_in_group("Ice"):
		body.melt()


func _on_Blaze_timer_timeout():
	$Blaze.monitoring = false


func refresh_blaze():
	can_blaze = true


func check_empty_fuel():
	if fuel <= 0: 
		return false
	return true


func add_fuel(amount):
	fuel += amount
	fuel = clamp(fuel, 0, max_fuel)
	print("Amount of fuel left: " + str(fuel))
	emit_signal("fuel_changed")


func spawn_blaze_particles():
	var blaze_emission = Blaze_emission.instance()
	blaze_emission.set_emission_radius(blaze_radius)
	blaze_emission.global_position = global_position
	get_owner().add_child(blaze_emission)
