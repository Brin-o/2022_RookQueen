extends YSort

var selected_piece
var turn = "Player"
var board : Board
var recolor : ColorManager
var player
var level : LevelInfo

export var one_at_a_time : bool = true
var next_piece_idx : int = 0
onready var main_scene = get_parent().get_node("MainScene")

var levels : Array = [
	preload("res://Levels/Level1.tscn"), 
	preload("res://Levels/Level2.tscn"),
	preload("res://Levels/Level3.tscn"),
	preload("res://Levels/Level4.tscn"),
	preload("res://Levels/Level5.tscn"), 
	preload("res://Levels/Level6.tscn"), 
	preload("res://Levels/Level7.tscn"), 
	preload("res://Levels/Level8.tscn"), 
	preload("res://Levels/Level9.tscn"),
	preload("res://Levels/Level10.tscn")] 

var player_hp = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace 


func _process(delta):
	if Input.is_action_just_released("ui_left"):
		change_level(level.num-1)
		pass
	if Input.is_action_just_pressed("ui_right"):
		change_level(level.num+1)
		pass
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
		get_tree().call_group("tile", "end_turn_effect")
		print("Enemy finished turn. Player goes.")


func enemy_turn():
	var i = 0
	var any_attacked = false

	#way more cumbersome than it should be but works for now
	if len(board.enemies) > 0:
		next_piece_idx = clamp(next_piece_idx, 0, len(board.enemies)-1)
		while not any_attacked:
			i=0
			for enemy in board.enemies:
				if not one_at_a_time:
					if len(enemy.can_move_to()) <= 0:
						enemy.do_random_move()
						yield(enemy, "finished_movement")
						any_attacked = true
				else:
					if i == next_piece_idx:
						if len(enemy.can_move_to()) <= 0:
							print(self, " cant do random move")
						elif not any_attacked:
							enemy.do_random_move()
							yield(enemy, "finished_movement")
							any_attacked = true
						next_piece_idx += 1
						next_piece_idx %= len(board.enemies)
						break
				i+=1
	else:
		change_level(level.num + 1)
	next_turn()

func show_tiles(should_show):
	var tiles = selected_piece.can_move_to()
	for tile_pos in tiles:
		board.set_selectable_outline(tile_pos, should_show)

func change_level(_num):
	player_hp = player.hp
	print("going to level", _num)
	level.call_deferred("queue_free")
	main_scene.add_child(levels[_num-1].instance())
	player_hp += 2
	
