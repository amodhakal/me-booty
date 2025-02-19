extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var gameObjects = $GameObjects
@onready var gameOverLabel = $GameOverLabel

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

# Maximum sprite size
const MAX_IMAGE_SIZE = Vector2(50, 50)

func _ready() -> void:
	gameOverLabel.hide()
	addInitialAssets()
	time.start()

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
		objectsInGame.append(area)

		# Handle clicking
		area.input_event.connect(_on_object_clicked.bind(area, object))

# Handles clicking on objects
func _on_object_clicked(viewport, event, shape_idx, area, object):
	if event is InputEventMouseButton and event.pressed:
		print("Clicked on:", object.texture.resource_path)
		# TODO: Handle proper and improper item in target picked
		area.queue_free()
		objectsInGame.erase(area)

# Update the timer label to show the remaining time
func updateTimerLabel():
	var secondsRemaining = ceil(time.time_left)
	
	if secondsRemaining <= 9:
		timeLabel.text = "0:0" + str(secondsRemaining)
	elif secondsRemaining <= 59:
		timeLabel.text = "0:" + str(secondsRemaining)
	else:
		secondsRemaining -= 60
		timeLabel.text = "1:" + ("0" + str(secondsRemaining) if secondsRemaining <= 9 else str(secondsRemaining))
