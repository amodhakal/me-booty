extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var gameObjects = $GameObjects
@onready var gameOverLabel = $GameOverLabel

# A list of all the hidden objects
var allAvailableObjects = [
	preload("res://images/Andy/lantern.png"),
	preload("res://images/Andy/map.png"),
	preload("res://images/Andy/scroll.png"),
	preload("res://images/Andy/ship.png"),
	preload("res://images/Andy/skull.png"),
	preload("res://images/Andy/sword.png"),
	preload("res://images/Andy/treasure.png"),
]

# The object that needs to be found
var currentTargetIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameOverLabel.hide()
	addInitialAssets()
	time.start()

# Run when the timer times out, 90 seconds
func _on_timer_timeout():
	# TODO: Game over if without finding all of the objects
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateTimerLabel()
	pass
	
# Initially add assets
func addInitialAssets():
	for texture in allAvailableObjects:
		# Create a new object
		var object = Sprite2D.new()
		object.texture = texture
		
#		# Select sprite position
		var viewport = get_viewport_rect().size
		object.position = Vector2(randf_range(50, viewport.x - 50), randf_range(50, viewport.y - 50))
		
		
	pass

# Update the timer label to show the time
func updateTimerLabel():
	var secondsRemaining = ceil(time.time_left)
	
	if ( secondsRemaining <= 9):
		timeLabel.text = "0:0" + str(secondsRemaining)
		return
	
	if (secondsRemaining <= 59):
		timeLabel.text = "0:" + str(secondsRemaining)
		return
		
	secondsRemaining -= 60
	if ( secondsRemaining <= 9 ):
		timeLabel.text = "1:0" + str(secondsRemaining)
		return
		
	timeLabel.text = "1:" + str(secondsRemaining)
