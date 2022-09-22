extends Node2D

var contains

var type

"""
Chasm: C
Floor: F
Wall: W
Ice: I
Spikes: S
Door: D
Key: K

Enemies will probably be numbered, assuming that they start on a Floor tile
"""

# Called when the node enters the scene tree for the first time.
func _ready():	
	_set_sprites()


func _process(delta):
	pass

func _set_sprites():
	#Show the correct sprite and hide all of the rest

	$ChasmSprite.visible = type == "C"
	$FloorSprite.visible = type == "F"
	$WallSprite.visible = type == "W"
	$IceSprite.visible = type == "I"
	$SpikesSprite.visible = type == "S"
	$DoorSprite.visible = type == "D"
	$KeySprite.visible = type == "K"

func is_walkable():
	return type == "F" or type == "I" or type == "S" or type == "D" or type == "K" 
