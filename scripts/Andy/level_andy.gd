extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var targetFrame = $Frame
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
const MAX_IMAGE_SIZE = Vector2(60, 60)

func _ready() -> void:
	print("Andy's level reached")
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
	var timeLabelRect = Rect2(timeLabel.get_global_transform().origin, timeLabel.size)
	var targetDisplayRect = Rect2(targetDisplay.get_global_transform().origin, targetDisplay.size)

	var targetFrameTexture = targetFrame.texture
	var targetFrameSize = Vector2.ZERO
	if targetFrameTexture: # Check if texture is loaded
		targetFrameSize = targetFrameTexture.get_size() * targetFrame.scale
	var targetFrameRect = Rect2(targetFrame.get_global_transform().origin - targetFrameSize / 2, targetFrameSize)


	var ui_rects_to_avoid = [timeLabelRect, targetDisplayRect, targetFrameRect]

	for texture in textures:
		var area = Area2D.new()
		var object = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()

		object.texture = texture
		object.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
		area.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

		var texture_size = object.texture.get_size()
		var scale_factor = min(MAX_IMAGE_SIZE.x / texture_size.x, MAX_IMAGE_SIZE.y / texture_size.y)
		object.scale = Vector2(scale_factor, scale_factor)
		shape.size = object.texture.get_size() * scale_factor
		collision.shape = shape

		var viewport = get_viewport_rect().size
		var sprite_size = shape.size
		var margin = 20
		var valid_position = false
		while not valid_position:
			var random_position = Vector2(randf_range(sprite_size.x / 2 + margin, viewport.x - sprite_size.x / 2 - margin), randf_range(sprite_size.y / 2 + margin, viewport.y - sprite_size.y / 2 - margin))
			area.position = random_position
			var area_rect = Rect2(area.global_position - sprite_size / 2, sprite_size)

			var overlaps_ui = false
			for ui_rect in ui_rects_to_avoid:
				if area_rect.intersects(ui_rect):
					overlaps_ui = true
					break

			var overlapping_areas = area.get_overlapping_areas()
			if overlapping_areas.size() == 0 and not overlaps_ui:
				valid_position = true

		collision.position = Vector2.ZERO
		area.add_child(collision)
		area.add_child(object)
		add_child(area)
		objectsInGame.append(object)

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

# Update the target display to show the correct object
func updateTargetDisplay():
	if objectsInGame.size() > 0:
		targetDisplay.texture = objectsInGame[targetIndex].texture
	else:
		handleWin()

# Handle end of the game
func handleEnd():
	for object in objectsInGame:
		object.hide()

	targetFrame.hide()
	timeLabel.hide()
	targetDisplay.hide()
	time.stop()

# Handle losing the game
func handleLoss():
	handleEnd()

	for object in objectsInGame:
		object.hide()
		
	get_tree().change_scene_to_file("res://scenes/Andy/defeat_screen.tscn")

# Handle winning the game
func handleWin():
	# Show to the next level or something
	gameWonLabel.show()
	handleEnd()
