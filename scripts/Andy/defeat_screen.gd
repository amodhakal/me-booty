extends Node2D

@onready var RestartGameButton = $RestartGameButton

func _ready():
	AudioManager.play_defeat_music()
	PointManager.addPoints(-200)

func _on_restart_game_button_pressed() -> void:
	AudioManager.restart_current_music()
	get_tree().change_scene_to_file("res://scenes/Andy/level_andy.tscn")
