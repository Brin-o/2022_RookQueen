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
	if type == "D":
		if len(GameManager.board.enemies)>0:
			visible = false
		else:
			visible = true
	pass

func _set_sprites():
	
	if color == "White":
		$Sprite.modulate = GameManager.recolor.colTileWhite;
	elif color == "Black":
		$Sprite.modulate = GameManager.recolor.colTileBlack;
	else:
		printerr("Wrong color in tile")

	if type == "S":
		spike_setcolor()
	if type == "W":
		$Sprite.modulate = GameManager.recolor.palettes["grays"][1]

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

func contains_player():
	return contains != null and contains.type == "Player"

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
			if contains == self:
				GameManager.show_tiles(false)
				GameManager.selected_piece = null
			else:
				GameManager.selected_piece = contains
				GameManager.show_tiles(true)
		elif GameManager.selected_piece != null:
			if pos in GameManager.selected_piece.can_move_to():
				GameManager.show_tiles(false)
				GameManager.selected_piece.move_to(pos)
				GameManager.selected_piece = null


func corner_border_generation():
	if type == "D":
		$EdgeBorderCorners.visible = false
		$BorderCorners.visible = false
		return

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
	pass


func end_turn_effect():
	if type=="S":
		if is_instance_valid(contains):
			#print(contains, "on location ", pos, " takes 1 dmg from spikes")
			$Sprite/SpikesSprite/Spike1.anim_play()
			$Sprite/SpikesSprite/Spike2.anim_play()

			contains.take_damage(1)
	pass


func spike_setcolor():
	$Sprite.modulate = Color(1,1,1)
	var target_c
	if color == "White":
		target_c = GameManager.recolor.colTileWhite;
	elif color == "Black":
		target_c = GameManager.recolor.colTileBlack;
	
	$Sprite/SpikesSprite/FloorSprite.self_modulate = target_c
	$Sprite/SpikesSprite/Spike1/Spike.self_modulate = GameManager.recolor.palettes["grays"][0]
	$Sprite/SpikesSprite/Spike1/SpikeOutline.self_modulate = GameManager.recolor.palettes["grays"][7]
	$Sprite/SpikesSprite/Spike2/Spike.self_modulate = GameManager.recolor.palettes["grays"][0]
	$Sprite/SpikesSprite/Spike2/SpikeOutline.self_modulate = GameManager.recolor.palettes["grays"][7]

	pass

func _on_KinematicBody2D_mouse_entered():
	
	if $Selection/Attack.visible:
		$Selection/AttackHover.visible = true;
		$Selection/Attack.scale = Vector2.ONE*1.25
	if $Selection/Move.visible:
		$Selection/MoveHover.visible = true;
		$Selection/Move.scale = Vector2.ONE*1.25

		if GameManager.selected_piece != null and GameManager.selected_piece.get_type() == "Bishop":
			GameManager.show_bishop_attack_tiles(pos)


func _on_KinematicBody2D_mouse_exited():
	$Selection/Move.scale = Vector2.ONE
	$Selection/Attack.scale = Vector2.ONE
	$Selection/MoveHover.visible = false;
	$Selection/AttackHover.visible = false;

	if GameManager.selected_piece != null and GameManager.selected_piece.get_type() == "Bishop":
		GameManager.hide_bishop_attack_tiles(pos)

func clean_tile():
	$Selection/Attack.visible = false
	$Selection/Move.visible = false
	$Selection/Move.scale = Vector2.ONE
	$Selection/Attack.scale = Vector2.ONE
	$Selection/MoveHover.visible = false;
	$Selection/AttackHover.visible = false;

