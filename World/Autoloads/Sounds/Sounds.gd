extends Node2D

var sound_dictionary = {
	"player_jump": preload("res://Assets/Audio/Jump.wav"),
	"player_blaze": preload("res://Assets/Audio/Blaze.wav"),
	"ice_break": preload("res://Assets/Audio/Ice break.wav"),
	"campfire_recharge": preload("res://Assets/Audio/Recharge.wav"),
	"goal_reach": preload("res://Assets/Audio/Reached.wav")}

export var Audio_player: PackedScene


func play_sound(key):
	var audio_player = Audio_player.instance()
	audio_player.stream = sound_dictionary[key]
	add_child(audio_player)
	audio_player.play()
