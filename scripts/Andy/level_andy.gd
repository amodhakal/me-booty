# TODO: Fix timer not updating label properly
# TODO: Prevent sprites from being on top of each other, and the labels

extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var gameObjects = $GameObjects
@onready var gameOverLabel = $GameOverLabel
@onready var gameWonLabel = $GameWonLabel

# A list of all the hidden objects' textures
var textures = [
	preload("res://images/Andy/lantern.png"),
	preload("res://images/Andy/map.png"),
	preload("res://images/Andy/scroll.png"),
	preload("res://images/Andy/ship.png"),
	preload("res://images/Andy/skull.png"),
	preload("res://images/Andy/sword.png"),
	preload("res://images/Andy/treasure.png"),
]

# The objects that are currently in-game
var objectsInGame = []

# Current target index
var targetIndex = 0

# Maximum sprite size
const MAX_IMAGE_SIZE = Vector2(50, 50)

func _ready() -> void:
	gameOverLabel.hide()
	gameWonLabel.hide()
	addInitialAssets()
	time.start()
	
func _process(delta: float) -> void:
	updateTimerLabel()
	
# Run when the timer times out, 90 seconds
func _on_timer_timeout():
	handleLoss()

# Initially add assets
func addInitialAssets():
	for texture in textures:
		# Create an Area2D for detecting clicks
		var area = Area2D.new()
		var object = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		object.texture = texture
		
		# Resize sprite while maintaining aspect ratio
		var texture_size = object.texture.get_size()
		var scale_factor = min(MAX_IMAGE_SIZE.x / texture_size.x, MAX_IMAGE_SIZE.y / texture_size.y)
		object.scale = Vector2(scale_factor, scale_factor)

		# Set sprite position randomly within the viewport
		var viewport = get_viewport_rect().size
		object.position = Vector2(randf_range(50, viewport.x - 50), randf_range(50, viewport.y - 50))
		
		# Match collision shape size to the resized sprite
		shape.size = object.texture.get_size() * scale_factor
		collision.shape = shape
		
		# Ensure collision shape is properly positioned
		collision.position = object.position
		
		# Organize node hierarchy
		area.add_child(collision)
		area.add_child(object)
		gameObjects.add_child(area)
		objectsInGame.append(object)

		# Handle clicking
		area.input_event.connect(_on_object_clicked.bind(area, object))
	
	updateTargetDisplay()

# Handles clicking on objects
func _on_object_clicked(viewport, event, shape_idx, area, object):
	if event is InputEventMouseButton and event.pressed:
		# Player loses if click the wrong item
		var correctObject = objectsInGame[targetIndex]
		if correctObject != object:
			handleLoss()
			return

		# Choose another object
		area.queue_free()
		objectsInGame.erase(object)
		updateTargetDisplay()

# Update the timer label to show the remaining time
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

func updateTargetDisplay():
	if objectsInGame.size() > 0:
		targetDisplay.texture = objectsInGame[targetIndex].texture
	else:
		handleWin()
		
# Handle losing the game
func handleLoss():
	gameOverLabel.show()
	timeLabel.hide()
	time.stop()

	
# Handle winning the game
func handleWin():
	# TODO: Show to the next level or something
	gameWonLabel.show()
	timeLabel.hide()
	time.stop()
