tool
extends StaticBody2D

export var piece_size : int = 25
export var columns : int = 1
export var rows : int = 1

onready var sprite_width = $Sprite.get_texture().get_width()
onready var sprite_height = $Sprite.get_texture().get_height()


func _ready():
	resize()


func _process(delta):
	if Engine.editor_hint: #For changing size in editor
		if Input.is_action_just_pressed("ui_accept"):
			resize()


func melt():
	Sounds.play_sound("ice_break")
	var side = figure_side()
	melt_ice(side)
	reposition_ice(side)
	check_size_ice()
	resize_sprite()


func figure_side(): #Figure what side is melted
	if get_tree().get_nodes_in_group("Player")[0] == null:
		return
	
	var player = get_tree().get_nodes_in_group("Player")[0]
	var pivot = $Pivot.global_position
	var gap = abs(player.global_position.y - pivot.y)
	
	if gap > $CollisionShape2D.shape.extents.y: #Player is up or down
		var altitude = player.global_position.y - pivot.y
		if altitude < 0: return "up"
		elif altitude > 0: return "down"
		
	elif gap < $CollisionShape2D.shape.extents.y: #Player is left or right
		var horizontal = player.global_position.x - pivot.x
		if horizontal < 0: return "left"
		elif horizontal > 0: return "right"


func melt_ice(side): #Melt ice and reposition ice
	if side == "left" or side == "right":
		$CollisionShape2D.shape.extents.x -= piece_size
	elif side == "up" or side == "down":
		$CollisionShape2D.shape.extents.y -= piece_size


func reposition_ice(side): #Reposition ice for one-side melt
	match side:
		"left": #(-1,0)
			global_position.x += piece_size
		"right": # (1,0)
			global_position.x -= piece_size
		"up":
			global_position.y += piece_size
		"down":
			global_position.y -= piece_size


func check_size_ice(): #Check if delete ice block or not
	if $CollisionShape2D.shape.extents.x <= 0 or \
		$CollisionShape2D.shape.extents.y <= 0:
		queue_free()


func resize(): #Resize into original size in editor
	$CollisionShape2D.shape.extents = \
		Vector2(piece_size * columns, piece_size * rows)
	resize_sprite()


func resize_sprite():
	$Sprite.scale.x = $CollisionShape2D.shape.extents.x * 2 / sprite_width
	$Sprite.scale.y = $CollisionShape2D.shape.extents.y * 2 / sprite_height
