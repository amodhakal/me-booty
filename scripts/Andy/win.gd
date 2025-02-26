extends Node2D
@onready var Points = $Points

func _ready() -> void:
	Points.text = "You won " + str(ceil(PointManager.getPoints())) + " points!"
	AudioManager.play_win_music()
