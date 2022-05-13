extends Node2D


func _ready():
	$Utilities/Goal.connect("goal_reached",self,"stage_completed")


func stage_completed():
	print("Stage completed!")
