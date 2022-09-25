extends YSort

var selected_piece
var turn = "Player"
var board : Board
var recolor : ColorManager
var player
export var one_at_a_time : bool = false
var next_piece_idx : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func set_selected_piece(piece):
	selected_piece = piece

func next_turn():
	if turn == "Player":
		print("Player finished turn. Enemy goes.")
		turn = "Enemy"
		enemy_turn()
	else:
		turn = "Player"
		print("Enemy finished turn. Player goes.")


func enemy_turn():
	var i = 0

	next_piece_idx = clamp(next_piece_idx, 0, len(board.enemies))
	for enemy in board.enemies:
		if not one_at_a_time or one_at_a_time and i == next_piece_idx:
			enemy.do_random_move()
			yield(enemy, "finished_movement")
		i+=1
	next_piece_idx += 1
	next_piece_idx %= len(board.enemies)
	
	next_turn()

func show_tiles(should_show):
	var tiles = selected_piece.can_move_to()
	for tile_pos in tiles:
		board.set_selectable_outline(tile_pos, should_show)
