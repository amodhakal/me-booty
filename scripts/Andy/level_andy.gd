extends Node2D

var timeLabel = Label
var time = Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeLabel = $TimerLabel
	time = $Timer
	
	time.start()

# Run when the timer times out, 90 seconds
func _on_timer_timeout():
	# TODO: Game over if without finding all of the objects
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateTimerLabel()
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
