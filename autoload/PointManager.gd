extends Node

@onready var points = 0

func getPoints():
	return points

func addPoints(point):
	points += point
