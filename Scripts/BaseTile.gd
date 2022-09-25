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
	$BorderCorners.visible = is_walkable()
	call_deferred("corner_border_generation")
	#corner_border_generation()


func _process(delta):
	pass

func _set_sprites():
	#Show the correct sprite and hide all of the rest

	if color == "White":
		$Sprite.modulate = GameManager.recolor.colTileWhite;
	elif color == "Black":
		$Sprite.modulate = GameManager.recolor.colTileBlack;
	else:
		printerr("Wrong color in tile")

	$Sprite/ChasmSprite.visible = type == "C"
	$Sprite/FloorSprite.visible = type == "."
	$Sprite/WallSprite.visible = type == "W"
	$Sprite/IceSprite.visible = type == "I"
	$Sprite/SpikesSprite.visible = type == "S"
	$Sprite/DoorSprite.visible = type == "D"
	$Sprite/KeySprite.visible = type == "K"

func is_walkable():
	return type == "." or type == "I" or type == "S" or type == "D" or type == "K" 

func contains_enemy():
	return contains != null and contains.type == "Enemy"

func contains_opponent(var check_type):
	var opponent = "Player" if check_type == "Enemy" else "Enemy"
	return contains != null and contains.type == opponent

func contains_ally(var check_type):
	return contains != null and contains.type == check_type

func _on_KinematicBody2D_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if GameManager.turn == "Enemy":
		return

	if event is InputEventMouseButton and event.pressed:

		if contains != null and contains.type != "Enemy":
			GameManager.selected_piece = contains
			GameManager.show_tiles(true)
		elif GameManager.selected_piece != null:
			if pos in GameManager.selected_piece.can_move_to():
				GameManager.show_tiles(false)
				GameManager.selected_piece.move_to(pos)
			GameManager.selected_piece = null


func corner_border_generation():

	# Check if its on the edge
	if pos.y == GameManager.board.board.size() -1:
		$EdgeBorderCorners/TopRight.visible = true
		$EdgeBorderCorners/BottomRight.visible = true
	if pos.y == 0:
		$EdgeBorderCorners/TopLeft.visible = true
		$EdgeBorderCorners/BottomLeft.visible = true
	if pos.x == GameManager.board.board.size() -1:
		$EdgeBorderCorners/BottomLeft.visible = true
		$EdgeBorderCorners/BottomRight.visible = true
	if pos.x == 0:
		$EdgeBorderCorners/TopLeft.visible = true
		$EdgeBorderCorners/TopRight.visible = true


	#topleft
	# if not GameManager.board.is_inbounds(Vector2(pos.x-1, pos.y-1)):
	# 	$EdgeBorderCorners/TopLeft.visible = true
	# #topright
	# if not GameManager.board.is_inbounds(Vector2(pos.x+1, pos.y-1)):
	# 	print("top right of ", pos, " is nothing")
	# 	$EdgeBorderCorners/TopRight.visible = true

	# # var target = Vector2(pos.x-1, pos.y+1)
	# # if not GameManager.board.is_inbounds(target):
	# # 	print(pos, "has no bottom right")
	# # 	$EdgeBorderCorners/BottomRight.visible = true	

	# if not GameManager.board.is_inbounds(Vector2(pos.x+1, pos.y+1)):
	# 	$EdgeBorderCorners/BottomRight.visible = true	
	pass
