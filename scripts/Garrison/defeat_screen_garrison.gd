extends Node2D

@onready var RestartGameButton = $RestartGameButton

func _ready():
	print("Defeat screen reached")

func _on_restart_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Garrison/level_garrison.tscn")
