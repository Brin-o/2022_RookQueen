extends Node2D

class_name BasePiece

signal finished_internal_movement
signal finished_movement
signal finished_push
signal finished_internal_push
signal took_damage
signal died

var current_tile : Vector2
var boardScene : Board
var type = "Player" #Player or Enemy
export var hp : int = 10
export var min_damage : int = 1
export var max_damage : int = 4

export var move_timer : float = 0.5

var moving : bool = false
var attacking : bool = false
var being_pushed : bool = false
var being_pushed_internal : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	boardScene = get_parent().get_node("Board")
	position = boardScene.board_position(current_tile)
	anim_start_movement(position, position)
	boardScene.set_tile_piece(current_tile, self)
	if type=="Enemy":
		$SpritePivot/Sprite.self_modulate = GameManager.recolor.colEnemy;
	connect("took_damage", $SpritePivot, "take_dmg")


func _physics_process(delta):
	anim_selection()
	anim_movement()

func can_move_to():
	assert(false, "Method not implemented!")

func move_to(var pos : Vector2):
	move_no_turn(pos)
	if type == "Player":
		yield(self, "finished_movement")
		GameManager.next_turn()

func _on_BasePiece_finished_movement():
	pass # Replace with function body.

func take_damage(damage : int):
	hp -= damage
	if hp <= 0:
		die()
		emit_signal("died")
		return true
	else:
		emit_signal("took_damage")
	return false

func die():
	boardScene.remove_from_enemies(self)
	queue_free()

func do_random_move():
	var possible_moves = can_move_to()
	if possible_moves.size() == 0:
		printerr("Trying to do random move but possible moves is empty!")
	else:
		move_to(possible_moves[randi()%possible_moves.size()])

func push(from : BasePiece, direction : Vector2):
	var pushed_to = current_tile + direction
	print("Pushing ",self, " from ", current_tile, " to ", pushed_to)
	being_pushed = true
	
	if not boardScene.is_inbounds(pushed_to):
		die()
		being_pushed = false
		return false
	
	elif boardScene.get_tile(pushed_to).type == "C":
		die()
		being_pushed = false
		return false

	elif boardScene.get_tile(pushed_to).type == "W":
		being_pushed_internal = true
		anim_start_movement(boardScene.board_position(current_tile), boardScene.board_position(pushed_to))
		yield(self, "finished_internal_push")
		anim_start_movement(boardScene.board_position(pushed_to), boardScene.board_position(current_tile))
		yield(self, "finished_internal_push")
		being_pushed_internal = false
		from.push(self, -direction)
		yield(from, "finished_push")
		emit_signal("finished_push")
		being_pushed = false
		return true
	
	elif boardScene.get_tile(pushed_to).contains_enemy():
		boardScene.get_tile(pushed_to).contains.push(self, direction)
		move_no_turn(pushed_to)
		yield(self, "finished_push")
		being_pushed = false
		return false
		#apply hit damage?

	else:
		move_no_turn(pushed_to)
		yield(self, "finished_push")
		being_pushed = false
		return true

func move_no_turn(var pos : Vector2):
	print(self, "Moving to ",pos)
	boardScene.set_tile_piece(current_tile, null)
	current_tile = pos
	var new_pos = boardScene.board_position(pos)
	anim_start_movement(position, new_pos)
	boardScene.set_tile_piece(current_tile, self)

func move_only_visual(var pos : Vector2):
	var new_pos = boardScene.board_position(pos)
	anim_start_movement(position, new_pos)

func move_only_logic(var pos : Vector2):
	boardScene.set_tile_piece(current_tile, null)
	current_tile = pos
	boardScene.set_tile_piece(current_tile, self)


# ANIMATIONS
# Animation Vars
var movement_lerp = 0
var movement_lerp_speed = 0.05

var mov_jump_height = 12

var mov_pos_old 
var mov_pos_new 

var pivot_pos = 7
var pivot_selected_pos = 3


func anim_selection():
	var pivot = $SpritePivot.position
	if type == "Player":
		if GameManager.selected_piece == self:
			$SpritePivot.position.y = lerp(pivot.y, pivot_selected_pos, 0.3)
		else:
			$SpritePivot.position.y = lerp(pivot.y, pivot_pos, 0.8)


func anim_start_movement(_op, _np):
	movement_lerp = 0
	mov_pos_old = _op
	mov_pos_new = _np
	pass

func anim_movement():
	movement_lerp = min(movement_lerp+movement_lerp_speed, 1)
	var _x = lerp(mov_pos_old.x, mov_pos_new.x, movement_lerp)
	var _y = lerp(mov_pos_old.y, mov_pos_new.y, movement_lerp) + Util.lenghtdir_y(mov_jump_height,180*movement_lerp)

	var _previous_moving = moving
	moving = position.x != _x or position.y != _y

	if not moving and _previous_moving:
		if being_pushed and not being_pushed_internal:
			print("Emitting finished push from ", self)
			emit_signal("finished_push")
		elif being_pushed and being_pushed_internal:
			print("Emitting finished push internal from ", self)
			emit_signal("finished_internal_push")
		elif attacking:
			print("Emitting finished internal movement ", self)
			emit_signal("finished_internal_movement")
		else:
			print("Emitting finished movement ", self)
			emit_signal("finished_movement")

	position.x = _x
	position.y = _y
	pass

func attack(_original_position, _attack_position):
	attacking = true
	anim_start_movement(_original_position, _attack_position)
	yield(self, "finished_internal_movement")
	anim_start_movement(_attack_position, _original_position)
	yield(self, "finished_internal_movement")
	attacking = false
	emit_signal("finished_movement")
	if type == "Player":
		GameManager.next_turn()

