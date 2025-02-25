extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var targetFrame = $Frame
@onready var gameWonLabel = $GameWonLabel

# A list of all the hidden objects' textures
var urls = [
	"res://images/Andy/lantern.png",
	"res://images/Andy/map.png",
	"res://images/Andy/scroll.png",
	"res://images/Andy/ship.png",
	"res://images/Andy/skull.png",
	"res://images/Andy/sword.png",
	"res://images/Andy/treasure.png",
	"res://images/Garrison/amulet_transparent.png",
	"res://images/Garrison/apple_transparent.png",
	"res://images/Garrison/bandana_transparent.png",
	"res://images/Garrison/blueprint_transparent.png",
	"res://images/Garrison/cannonball_transparent.png",
	"res://images/Garrison/dagger_transparent.png",
	"res://images/Garrison/diamond_transparent.png",
	"res://images/Garrison/doubloon_transparent.png",
	"res://images/Garrison/elixir_transparent.png",
	"res://images/Garrison/fools_gold_transparent.png",
	"res://images/Garrison/golden_apple_transparent.png",
	"res://images/Garrison/key_transparent.png",
	"res://images/Garrison/map_transparent.png",
	"res://images/Garrison/marbles_transparent.png",
	"res://images/Garrison/pearl_transparent.png",
	"res://images/Garrison/pineapple_transparent.png",
	"res://images/Garrison/pistol_transparent.png",
	"res://images/Garrison/poisoned_rum_transparent.png",
	"res://images/Garrison/rotten_apple_transparent.png",
	"res://images/Garrison/rotten_pineapple_transparent.png",
	"res://images/Garrison/ruby_transparent.png",
	"res://images/Garrison/rum_transparent.png",
	"res://images/Garrison/sapphire_transparent.png",
	"res://images/Garrison/silver_transparent.png",
	"res://images/Garrison/sword_transparent.png",
	"res://images/Garrison/treasure_chest_closed_transparent.png",
	"res://images/Garrison/treasure_chest_transparent.png",
	"res://images/Muzamani/birdcage_transparent.png",
	"res://images/Muzamani/brigmap_transparent.png",
	"res://images/Muzamani/brigpistol_transparent.png",
	"res://images/Muzamani/compass_transparent.png",
	"res://images/Muzamani/eyepatch_transparent.png",
	"res://images/Muzamani/goldoubloons_transparent.png",
	"res://images/Muzamani/pirateflag_transparent.png",
	"res://images/Muzamani/prisonfood_transparent.png"
]

# The objects that are currently in-game (stores Sprite2D nodes)
var objectsInGame = []

# Current target index
var targetIndex = 0

# Maximum sprite size
const MAX_IMAGE_SIZE = Vector2(60, 60)

func _ready() -> void:
	print("Andy's level reached")
	gameWonLabel.hide()
	addInitialAssets()
	


func _process(delta: float) -> void:
	updateTimerLabel()

# Run when the timer times out, 90 seconds
func _on_timer_timeout():
	handleLoss()

# Initially add assets
func addInitialAssets():
	urls.shuffle()
	var timeLabelRect = Rect2(timeLabel.get_global_transform().origin, timeLabel.size)
	var targetDisplayRect = Rect2(targetDisplay.get_global_transform().origin, targetDisplay.size)

	var targetFrameTexture = targetFrame.texture
	var targetFrameSize = Vector2.ZERO
	if targetFrameTexture: # Check if texture is loaded
		targetFrameSize = targetFrameTexture.get_size() * targetFrame.scale
	var targetFrameRect = Rect2(targetFrame.get_global_transform().origin - targetFrameSize / 2, targetFrameSize)

	var ui_rects_to_avoid = [timeLabelRect, targetDisplayRect, targetFrameRect]

	for url in urls:
		var texture = load(url)
		var area = Area2D.new()
		var object = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()

		object.texture = texture

		# You can adjust z_index as needed
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
		
		# Option B: Check against UI and already-placed objects manually
		while not valid_position:
			var random_position = Vector2(
				randf_range(sprite_size.x / 2 + margin, viewport.x - sprite_size.x / 2 - margin),
				randf_range(sprite_size.y / 2 + margin, viewport.y - sprite_size.y / 2 - margin)
			)
			area.position = random_position
			var area_rect = Rect2(area.global_position - sprite_size / 2, sprite_size)

			# Check against UI rectangles
			var overlaps_ui = false
			for ui_rect in ui_rects_to_avoid:
				if area_rect.intersects(ui_rect):
					overlaps_ui = true
					break

			# Check against already placed objects
			var overlaps_object = false
			for other_object in objectsInGame:
				# Retrieve the parent Area2D of the sprite
				var other_area = other_object.get_parent()
				var other_sprite_size = other_object.texture.get_size() * other_object.scale
				var other_rect = Rect2(other_area.global_position - other_sprite_size / 2, other_sprite_size)
				if area_rect.intersects(other_rect):
					overlaps_object = true
					break

			if not overlaps_ui and not overlaps_object:
				valid_position = true

		collision.position = Vector2.ZERO
		area.add_child(collision)
		area.add_child(object)
		add_child(area)
		objectsInGame.append(object)

		# Bind the input event with additional parameters (area and object)
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

	if (secondsRemaining <= 9):
		timeLabel.text = "0:0" + str(secondsRemaining)
		return

	if (secondsRemaining <= 59):
		timeLabel.text = "0:" + str(secondsRemaining)
		return

	secondsRemaining -= 60
	if (secondsRemaining <= 9):
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
		
	get_tree().change_scene_to_file("res://scenes/Garrison/defeat_screen_garrison.tscn")

# Handle winning the game
func handleWin():
	gameWonLabel.show()
	handleEnd()
	get_tree().change_scene_to_file("res://scenes/Muzamani/brigscene.tscn")
