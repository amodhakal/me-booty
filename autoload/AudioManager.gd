extends Node

@onready var main_music = preload("res://audio/music.mp3")
@onready var defeat_music = preload("res://audio/dead.mp3")
@onready var win_music = preload("res://audio/win.mp3")
var current_track = ""
var music_player: AudioStreamPlayer

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.connect("finished", Callable(self, "_on_music_finished"))

func play_main_music():
	current_track = "main"
	music_player.stream = main_music
	music_player.play()

func play_defeat_music():
	current_track = "defeat"
	music_player.stream = defeat_music
	music_player.play()
		
func play_win_music():
	current_track = "win"
	music_player.stream = win_music
	music_player.play()

func _on_music_finished():
	if current_track == "main":
		music_player.play()
