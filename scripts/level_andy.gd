extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var targetFrame = $Frame

var objectsInGame = []
var targetIndex = 0

const NEXT_SCENE = "res://scenes/level_garrison.tscn"
const LOSS_SCENE = "res://scenes/defeat_screen.tscn"
const MULTIPLYER = 10

func _ready() -> void:
	Utils.generateAssets(timeLabel, targetDisplay, targetFrame, get_viewport_rect(), objectsInGame, targetIndex, time, LOSS_SCENE, NEXT_SCENE, MULTIPLYER)

func _process(delta: float) -> void:
	Utils.updateTimerLabel(time, timeLabel)

func _on_timer_timeout():
	Utils.handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, LOSS_SCENE)
