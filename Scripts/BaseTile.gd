extends Node2D

var contains
var pos : Vector2
var type
var color

"""
Chasm: C
Floor: F
Wall: W
Ice: I
Spikes: S
Door: D
Key: K


Pawn: P p
Bishop: B b
Horse: H h
Queen: Q q
Rook: R r
Enemies will probably be numbered, assuming that they start on a Floor tile
"""

# Called when the node enters the scene tree for the first time.
func _ready():	
	_set_sprites()


func _process(delta):
	pass

func _set_sprites():
	#Show the correct sprite and hide all of the rest

	if color == "White":
		modulate = Color(1,1,1)
	elif color == "Black":
		modulate = Color(0,0,0)
	else:
		printerr("Wrong color in tile")

	$ChasmSprite.visible = type == "C"
	$FloorSprite.visible = type == "F"
	$WallSprite.visible = type == "W"
	$IceSprite.visible = type == "I"
	$SpikesSprite.visible = type == "S"
	$DoorSprite.visible = type == "D"
	$KeySprite.visible = type == "K"

func is_walkable():
	return type == "F" or type == "I" or type == "S" or type == "D" or type == "K" 

func contains_enemy():
	return contains != null and contains.type == "Enemy"

func contains_opponent(var check_type):
	var opponent = "Player" if check_type == "Enemy" else "Enemy"
	return contains != null and contains.type == opponent

func _on_KinematicBody2D_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if GameManager.turn == "Enemy":
		return

	if event is InputEventMouseButton and event.pressed:

		if contains != null and contains.type != "Enemy":
			GameManager.selected_piece = contains		
		elif GameManager.selected_piece != null:
			if pos in GameManager.selected_piece.can_move_to():
				GameManager.selected_piece.move_to(pos)
			GameManager.selected_piece = null
		


