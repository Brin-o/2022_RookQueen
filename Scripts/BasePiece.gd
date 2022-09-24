extends Node2D

class_name BasePiece

signal finished_movement

var current_tile : Vector2
var boardScene : Board
var type = "Player" #Player or Enemy
export var hp : int = 10
export var damage : int = 1
export var move_timer : float = 0.5


# Animation Vars
var pivot_pos = 7
var pivot_selected_pos = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	boardScene = get_parent().get_node("Board")
	position = boardScene.board_position(current_tile)
	boardScene.set_tile_piece(current_tile, self)
	if type=="Enemy":
		$SpritePivot/Sprite.self_modulate = GameManager.recolor.colEnemy;


func _physics_process(delta):
	var pivot = $SpritePivot.position
	if type == "Player":
		if GameManager.selected_piece == self or $Tween.is_active():
			$SpritePivot.position.y = lerp(pivot.y, pivot_selected_pos, 0.3)
		else:
			$SpritePivot.position.y = lerp(pivot.y, pivot_pos, 0.8)

func can_move_to():
	assert(false, "Method not implemented!")

func move_to(var pos : Vector2):
	move_no_turn(pos)
	if type == "Player":
		GameManager.next_turn()

func _on_BasePiece_finished_movement():
	pass # Replace with function body.

func take_damage(damage : int):
	hp -= damage
	if hp <= 0:
		die()
		return true
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
	
	if not boardScene.is_inbounds(pushed_to):
		die()
		return true
	
	elif boardScene.get_tile(pushed_to).type == "C":
		die()
		return true

	elif boardScene.get_tile(pushed_to).type == "W":
		from.push(self, -direction)
		return false
	
	elif boardScene.get_tile(pushed_to).contains_enemy():
		var can_go = boardScene.get_tile(pushed_to).contains.push(self, direction)
		if can_go:
			move_no_turn(pushed_to)
		return true
		#apply hit damage?

	else:
		move_no_turn(pushed_to)
		return true

func move_no_turn(var pos : Vector2):
	boardScene.set_tile_piece(current_tile, null)
	current_tile = pos
	var target_position = boardScene.board_position(pos)
	var t : Tween = $Tween
	t.interpolate_property(self, "position", null, target_position, move_timer, Tween.TRANS_CUBIC, Tween.EASE_OUT) 
	t.start()
	boardScene.set_tile_piece(current_tile, self)
