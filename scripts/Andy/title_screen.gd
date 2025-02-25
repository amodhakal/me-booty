extends Node2D

@onready var StartGameButton = $StartGameButton

func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Andy/level_andy.tscn")
