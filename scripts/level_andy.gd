extends Node2D

@onready var time = $Timer
@onready var timeLabel = $TimerLabel
@onready var targetDisplay = $TargetDisplay
@onready var targetFrame = $Frame

var objectsInGame = []
var targetIndex = 0

const MAX_IMAGE_SIZE = Vector2(60, 60)
const NEXT_SCENE = "res://scenes/level_garrison.tscn"
const LOSS_SCENE = "res://scenes/defeat_screen.tscn"
const MULTIPLYER = 10

func _ready() -> void:
	var timeLabelRect = Rect2(timeLabel.get_global_transform().origin, timeLabel.size)
	var targetDisplayRect = Rect2(targetDisplay.get_global_transform().origin, targetDisplay.size)
	var targetFrameTexture = targetFrame.texture
	var targetFrameSize = Vector2.ZERO

	if targetFrameTexture:
		targetFrameSize = targetFrameTexture.get_size() * targetFrame.scale
		
	var targetFrameRect = Rect2(targetFrame.get_global_transform().origin - targetFrameSize / 2, targetFrameSize)
	var ui_rects_to_avoid = [timeLabelRect, targetDisplayRect, targetFrameRect]

	for url in Utils.getTextureURLS():
		var texture = load(url)
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
		area.input_event.connect(_on_object_clicked.bind(area, object))

	Utils.updateTargetDisplay(targetIndex, objectsInGame, targetFrame, timeLabel, targetDisplay, time, NEXT_SCENE, MULTIPLYER)

func _process(delta: float) -> void:
	Utils.updateTimerLabel(time, timeLabel)

func _on_timer_timeout():
	Utils.handleLoss(objectsInGame, targetFrame, timeLabel, targetDisplay, time, LOSS_SCENE)

func _on_object_clicked(viewport, event, shape_idx, area, object):
	Utils.assetClicked(viewport, event, shape_idx, area, object, objectsInGame, targetIndex, targetFrame, timeLabel, targetDisplay,time, LOSS_SCENE, NEXT_SCENE, MULTIPLYER)
