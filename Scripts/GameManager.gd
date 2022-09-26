extends YSort

signal selected_new_piece
signal mouse_click

var selected_piece
var turn = "Player"
var board : Board
var recolor : ColorManager
var player
var level : LevelInfo
var camera
var ui
var next_player_piece = "p"
var skip_piece_pick_in_levels = [0,1,2,3]
var lost = false

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

func _input(event):
	if(event is InputEventMouseButton and event.is_pressed() and not event.is_echo()):
		emit_signal("mouse_click")

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



var flavourText =["lvl1", "lvl2", "lvl3", "we stormed past the knights", "their towers did not protect them from us", "the four bishops tried to oppose us", "even some of our own betrayed us", "but we prevailed", "it was the king and his bodyguards", "not even the queen could stop us"]
func change_level(_num):
	yield(get_tree().create_timer(0.1), "timeout")
	if player != null and player.hp != null:
		player_hp = player.hp
	level.call_deferred("queue_free")
	main_scene.add_child(levels[_num-1].instance())
	board.generate_board_no_enemies()
	if not _num in skip_piece_pick_in_levels:
		print(level.num)
		main_scene.get_node("UI/Selection").visible = true
		main_scene.get_node("UI/Selection").flavour_text(flavourText[_num-1])
		yield(self, "selected_new_piece")
		main_scene.get_node("UI/Selection").visible = false
	
	board.generate_enemies()

	camera.target_z = rand_range(0.9,1.2)
	camera.target_rot = rand_range(-3,3)
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
	print("SELECTED: ", _piece)
	next_player_piece = _piece
	player_hp+=bouns_hp
	emit_signal("selected_new_piece")

func find_player():
	for tiles in board.board:
		for tile in tiles:
			if tile.contains_player():
				player = tile.contains

var lose_msg = ["""you have 
failed""","""your attempts
are futile""",
"""the monarch
prevails""", """the rebelion
is crushed""" ]
func lose_animation():
	camera.lose()
	var t = Util.choose(lose_msg)
	for l in ui.get_node("LoseScreen").get_children():
		l.text = t
	yield(self, "mouse_click")
	restart()
	for l in ui.get_node("LoseScreen").get_children():
		l.text = ""

func restart():
	next_player_piece = "p"
	change_level(1)	
