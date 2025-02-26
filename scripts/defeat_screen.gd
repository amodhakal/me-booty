extends Node2D

@onready var RestartGameButton = $RestartGameButton

func _ready():
	AudioManager.play_defeat_music()
	PointManager.addPoints(-200)

func _on_restart_game_button_pressed() -> void:
	AudioManager.play_main_music()
	get_tree().change_scene_to_file("res://scenes/level_andy.tscn")
