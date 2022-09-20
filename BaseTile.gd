extends Node2D

var contains

var type

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$WhiteSprite.visible = type == 1
	$BlackSprite.visible = type == 2


func _process(delta):
	pass
