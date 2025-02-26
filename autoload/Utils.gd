extends Node

var urls = [
	"res://images/lantern.png",
	"res://images/map.png",
	"res://images/scroll.png",
	"res://images/ship.png",
	"res://images/skull.png",
	"res://images/sword_transparent.png",
	"res://images/treasure.png",
	"res://images/amulet_transparent.png",
	"res://images/apple_transparent.png",
	"res://images/bandana_transparent.png",
	"res://images/blueprint_transparent.png",
	"res://images/cannonball_transparent.png",
	"res://images/dagger_transparent.png",
	"res://images/diamond_transparent.png",
	"res://images/doubloon_transparent.png",
	"res://images/elixir_transparent.png",
	"res://images/fools_gold_transparent.png",
	"res://images/golden_apple_transparent.png",
	"res://images/key_transparent.png",
	"res://images/map_transparent.png",
	"res://images/marbles_transparent.png",
	"res://images/pearl_transparent.png",
	"res://images/pineapple_transparent.png",
	"res://images/pistol_transparent.png",
	"res://images/poisoned_rum_transparent.png",
	"res://images/rotten_apple_transparent.png",
	"res://images/rotten_pineapple_transparent.png",
	"res://images/ruby_transparent.png",
	"res://images/rum_transparent.png",
	"res://images/sapphire_transparent.png",
	"res://images/silver_transparent.png",
	"res://images/treasure_chest_closed_transparent.png",
	"res://images/treasure_chest_transparent.png",
	"res://images/birdcage_transparent.png",
	"res://images/brigmap_transparent.png",
	"res://images/brigpistol_transparent.png",
	"res://images/compass_transparent.png",
	"res://images/eyepatch_transparent.png",
	"res://images/goldoubloons_transparent.png",
	"res://images/pirateflag_transparent.png",
	"res://images/prisonfood_transparent.png"
]

func getTextureURLS():
	urls.shuffle()
	return urls
	
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

	targetFrame.hide()
	timeLabel.hide()
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
