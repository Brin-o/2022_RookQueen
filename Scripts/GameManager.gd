extends Node2D

var selected_piece : BasePiece
var turn = "Player"
var board : Board
var recolor : ColorManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func set_selected_piece(piece):
	selected_piece = piece

func next_turn():
	if turn == "Player":
		turn = "Enemy"
		enemy_turn()
	else:
		turn = "Player"

func enemy_turn():
	# Very basic turn: one of the enemies randomly moves, the rest does nothing
	#for enemy in board.enemies:
	#	enemy.do_random_move()
	
	# Timer?
	next_turn()

func show_tiles(should_show):
	var tiles = selected_piece.can_move_to()
	for tile_pos in tiles:
		board.set_selectable_outline(tile_pos, should_show)
