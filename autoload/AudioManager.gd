extends Node

# AudioManager.gd - Place this script in an autoload singleton

var current_track = ""
var music_player: AudioStreamPlayer
var defeat_music: AudioStream
var main_music: AudioStream
var win_music: AudioStream

func _ready():
	# Create an AudioStreamPlayer as a child of this node
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Load music resources
	main_music = load("res://audio/music.mp3")
	defeat_music = load("res://audio/dead.mp3")
	win_music = load("res://audio/win.mp3")
	
	# Set up signals for finished tracks if you want looping behavior
	music_player.connect("finished", Callable(self, "_on_music_finished"))

func play_main_music():
	if current_track != "main":
		current_track = "main"
		music_player.stream = main_music
		music_player.play()

func play_defeat_music():
	if current_track != "defeat":
		current_track = "defeat"
		music_player.stream = defeat_music
		music_player.play()
		
func play_win_music():
	if current_track != "win":
		current_track = "win"
		music_player.stream = win_music
		music_player.play()

func stop_music():
	music_player.stop()
	current_track = ""

func restart_current_music():
	music_player.stop()
	play_main_music()

func _on_music_finished():
	if current_track == "win":
		return
		
	# Auto-loop current track
	if current_track != "":
		music_player.play()
