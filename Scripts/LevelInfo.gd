extends Node2D

export var num : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.level = self
