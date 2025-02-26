extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var targetFrame = $Frame

var objectsInGame = []
var targetIndex = 0

const NEXT_SCENE = "res://scenes/Win.tscn"
const LOSS_SCENE = "res://scenes/brig_defeat.tscn"
const MULTIPLYER = 50

func _ready() -> void:
	Utils.generateAssets(timeLabel, targetDisplay, targetFrame, get_viewport_rect(), objectsInGame, targetIndex, time, LOSS_SCENE, NEXT_SCENE, MULTIPLYER, 1)

func _process(delta: float) -> void:
	Utils.updateTimerLabel(time, timeLabel)

func _on_timer_timeout():
	Utils.handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, LOSS_SCENE)
