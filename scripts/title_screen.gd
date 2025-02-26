extends Node2D

@onready var StartGameButton = $StartGameButton

func _ready():
	AudioManager.play_main_music()

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_andy.tscn")
