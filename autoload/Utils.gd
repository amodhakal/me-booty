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
