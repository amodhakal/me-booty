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
	generateAssets(timeLabel, targetDisplay, targetFrame, get_viewport_rect(), objectsInGame, targetIndex, time, LOSS_SCENE, NEXT_SCENE, MULTIPLYER, .6)

func _process(delta: float) -> void:
	updateTimerLabel(time, timeLabel)

func _on_timer_timeout():
	handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, LOSS_SCENE)

func generateAssets(timeLabel, targetDisplay, targetFrame, viewportRect, objectsInGame, targetIndex, time, lossScene, nextScene, multiplyer, percentage):
	var objectClicked = func(viewport, event, shape_idx, area, object):
		assetClicked(viewport, event, shape_idx, area, object, objectsInGame, targetIndex, targetFrame, timeLabel, targetDisplay,time, lossScene, nextScene, multiplyer)

	var timeLabelRect = Rect2(timeLabel.get_global_transform().origin, timeLabel.size)
	var targetDisplayRect = Rect2(targetDisplay.get_global_transform().origin, targetDisplay.size)
	var targetFrameTexture = targetFrame.texture
	var targetFrameSize = Vector2.ZERO

	if targetFrameTexture:
		targetFrameSize = targetFrameTexture.get_size() * targetFrame.scale
		
	var targetFrameRect = Rect2(targetFrame.get_global_transform().origin - targetFrameSize / 2, targetFrameSize)
	var ui_rects_to_avoid = [timeLabelRect, targetDisplayRect, targetFrameRect]
	var urls = Utils.getTextureURLS()
	
	urls = urls.slice(0, int(urls.size() * percentage))
	for url in urls:
		var texture = load(url)
		var area = Area2D.new()
		var object = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()

		object.texture = texture
		object.z_index = RenderingServer.CANVAS_ITEM_Z_MAX
		area.z_index = RenderingServer.CANVAS_ITEM_Z_MAX

		var texture_size = object.texture.get_size()
		var scale_factor = min(Utils.MAX_IMAGE_SIZE.x / texture_size.x, Utils.MAX_IMAGE_SIZE.y / texture_size.y)
		
		object.scale = Vector2(scale_factor, scale_factor)
		shape.size = object.texture.get_size() * scale_factor
		collision.shape = shape

		var viewport = viewportRect.size
		var sprite_size = shape.size
		var margin = 20
		var valid_position = false
		
		while not valid_position:
			var random_position = Vector2(
				randf_range(sprite_size.x / 2 + margin, viewport.x - sprite_size.x / 2 - margin),
				randf_range(sprite_size.y / 2 + margin, viewport.y - sprite_size.y / 2 - margin)
			)

			area.position = random_position
			var area_rect = Rect2(area.global_position - sprite_size / 2, sprite_size)

			var overlaps_ui = false
			for ui_rect in ui_rects_to_avoid:
				if area_rect.intersects(ui_rect):
					overlaps_ui = true
					break

			var overlaps_object = false
			for other_object in objectsInGame:
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
		area.input_event.connect(objectClicked.bind(area, object))

	updateTargetDisplay(targetIndex, objectsInGame, targetFrame, timeLabel, targetDisplay, time, nextScene, multiplyer)

	
func assetClicked(viewport, event, shape_idx, area, object, objectsInGame, targetIndex, targetFrame, timeLabel, targetDisplay,time, lossScene, winScene, multiplyer):
	if event is InputEventMouseButton and event.pressed:
		var correctObject = objectsInGame[targetIndex]
		if correctObject != object:
			handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, lossScene)
			return

		area.queue_free()
		objectsInGame.erase(object)
		updateTargetDisplay(targetIndex, objectsInGame, targetFrame, timeLabel, targetDisplay, time, winScene, multiplyer)

func updateTimerLabel(time, timeLabel):
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

func updateTargetDisplay(targetIndex, objectsInGame, targetFrame, timeLabel, targetDisplay, time, scene, multiplyer):
	if objectsInGame.size() > 0:
		targetDisplay.texture = objectsInGame[targetIndex].texture
	else:
		handleWin(objectsInGame, targetFrame, timeLabel, targetDisplay, time, scene, multiplyer)
	
func handleEnd(objectsInGame, targetFrame, timeLabel, targetDisplay, time):
	for object in objectsInGame:
		object.hide()

	if targetFrame:
		targetFrame.hide()
	if timeLabel:
		timeLabel.hide()
	if targetDisplay:
		targetDisplay.hide()
	time.stop()

func handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, scene):
	handleEnd(objectsInGame, targetFrame, timeLabel, targetDisplay, time)
	for object in objectsInGame:
		object.hide()
		
	get_tree().change_scene_to_file(scene)

func handleWin(objectsInGame, targetFrame, timeLabel, targetDisplay, time, scene, multiplyer):
	PointManager.addPoints(ceil(time.time_left) * multiplyer)
	handleEnd(objectsInGame, targetFrame, timeLabel, targetDisplay, time)
	get_tree().change_scene_to_file(scene)
