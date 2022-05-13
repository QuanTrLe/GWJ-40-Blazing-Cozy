extends Node2D

export (String, FILE) var next_scene


func _ready():
	$Utilities/Goal.connect("goal_reached",self,"stage_completed")
	$Player.connect("fuel_changed", self, "fuel_changed")
	fuel_changed()


func stage_completed():
	get_tree().change_scene(next_scene)


func fuel_changed():
	$Control/CanvasLayer/Fuel_label.text = \
		str($Player.fuel) + " / " + str($Player.max_fuel) 
