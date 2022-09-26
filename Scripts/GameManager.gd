extends YSort

signal selected_new_piece

var selected_piece
var turn = "Player"
var board : Board
var recolor : ColorManager
var player
var level : LevelInfo
var camera
var next_player_piece = "p"

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
		hide_all_tiles()
		yield(get_tree().create_timer(rand_range(0.3,0.6)), "timeout")
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
						show_next_attack_tiles(board.enemies[next_piece_idx])
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
	level.call_deferred("queue_free")
	main_scene.add_child(levels[_num-1].instance())
	board.generate_board_no_enemies()
	main_scene.get_node("UI/Selection").visible = false
	yield(get_tree().create_timer(3), "timeout")
	main_scene.get_node("UI/Selection").visible = true
	yield(self, "selected_new_piece")
	main_scene.get_node("UI/Selection").visible = false
	board.generate_enemies()
	#board.set_visible_enemies(false)
	
func show_next_attack():
	board.enemies[next_piece_idx].set_active_piece(true)

func show_next_attack_tiles(piece):
	for enemy in board.enemies:
		enemy.set_active_piece(enemy == piece)

func show_bishop_attack_tiles(var pos):
	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]

	for dir in directions:
		var attack_pos = pos + dir
		if board.is_inbounds(attack_pos):
			var t = board.get_tile(attack_pos)
			t.get_node("Selection/Attack").visible = true

func hide_bishop_attack_tiles(var pos):
	var directions = [Vector2(0,-1), Vector2(0,1), Vector2(1,0), Vector2(-1,0)]

	for dir in directions:
		var attack_pos = pos + dir
		if board.is_inbounds(attack_pos):
			var t = board.get_tile(attack_pos)
			t.get_node("Selection/Attack").visible = false
			t.get_node("Selection/AttackHover").visible = false
			t.get_node("Selection/Attack").scale = Vector2.ONE
	

func hide_all_tiles():
	if board != null and board.board != null:
		for tiles in board.board:
			for tile in tiles:
				tile.clean_tile()


func upgrade_piece(_piece : String, bouns_hp : int):
	next_player_piece = _piece
	player_hp+=bouns_hp
	emit_signal("selected_new_piece")
