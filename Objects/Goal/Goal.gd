extends Sprite

signal goal_reached


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		Sounds.play_sound("goal_reach")
		emit_signal("goal_reached")
