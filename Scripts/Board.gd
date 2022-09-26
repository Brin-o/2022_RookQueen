extends Node

class_name Board

var board : Array
var offset
var res = 216
export (PackedScene) var tile_scene

export(PackedScene) var pawn
export(PackedScene) var bishop
export(PackedScene) var horse
export(PackedScene) var queen
export(PackedScene) var rook
export(PackedScene) var king


var enemies_type = ["P", "p", "B", "b", "H", "h", "Q", "q", "R", "r", "K", "k"]
var enemies : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_board()
	read_file()
	GameManager.board = self
	

func read_file():
	var file = File.new()
	file.open("res://Levels/level" + str(get_parent().num) + ".txt", file.READ)
	var content = file.get_as_text()
	return content.split("\n")


func generate_board():
	var lines : Array = read_file()
	var row = 0
	var column = 0
	board = []

	var tile_instance = tile_scene.instance()
	var tile_size = tile_instance.get_node("Sprite/FloorSprite").texture.get_size().x * tile_instance.get_node("Sprite/FloorSprite").scale.x + 4
	offset = res/2 - ((len(lines)-1) * (tile_size/2))
	
	for line in lines:
		board.append([])
		for tile in line:
			var new_tile = tile_scene.instance()
			new_tile.position = Vector2(column * tile_size + offset,row * tile_size + offset)
			new_tile.pos = Vector2(row, column)
			new_tile.color = "White" if(row%2==0 and column%2!=0 or row%2!=0 and column%2==0) else "Black"
			if tile in enemies_type:
				new_tile.type = "."
				spawn_piece(tile, new_tile.pos)
			else:
				new_tile.type = tile
			add_child(new_tile)
			board[row].append(new_tile)
			column += 1
		row += 1
		column = 0
	if len(enemies)>0:
		enemies[0].set_active_piece(true)

func get_tile(pos):
	assert(is_inbounds(pos), "You were trying to access an out of bounds position")
	return board[pos.x][pos.y]

func set_tile_piece(var tile_pos : Vector2, piece):
	get_tile(tile_pos).contains = piece

func board_position(pos):
	return get_tile(pos).position

func is_inbounds(new_pos: Vector2):
	if new_pos.x < 0 or new_pos.y < 0:
		return false

	if new_pos.x >= board.size():
		return false

	if new_pos.y >= board[new_pos.x].size():
		return false
		
	return true

func is_steppable(new_pos: Vector2):
	var inbounds = is_inbounds(new_pos)

	if not inbounds:
		return false

	return board[new_pos.x][new_pos.y].is_walkable()

func spawn_piece(tile : String, pos : Vector2):
	var piece = null
	
	match(tile):
		"P","p":
			piece = pawn.instance()
		"B","b":
			piece = bishop.instance()
		"H","h":
			piece = horse.instance()
		"Q","q":
			piece = queen.instance()
		"R","r":
			piece = rook.instance()
		"K","k":
			piece = king.instance()
		_:
			printerr("Wrong enemy character")

	piece.current_tile = pos
	piece.type = "Player" if tile == tile.to_lower() else "Enemy"
	if piece.type == "Enemy":
		enemies.append(piece)
	else:
		GameManager.player = piece
	get_parent().call_deferred("add_child", piece)

func remove_from_enemies(enemy):
	enemies.erase(enemy)

func set_selectable_outline(var pos : Vector2, should_show : bool):
	var tile = get_tile(pos)
	tile.get_node("Selection/Attack").visible = should_show and tile.contains_enemy()
	tile.get_node("Selection/Move").visible = should_show and not tile.contains_enemy()

func is_pawn_on_edge(piece):
	var t = piece.current_tile
	var type = piece.type

	match(type):
		"Player":
			return t.x == 0
		"Enemy":
			return t.x == len(board)-1

func check_promote(piece):
	if piece.type == "Enemy" and is_pawn_on_edge(piece):
		promote(piece)
		GameManager.show_next_attack()
		GameManager.next_turn()

func promote(piece):
	var tile = piece.current_tile 
	remove_from_enemies(piece)
	get_tile(tile).contains = null
	piece.queue_free()

	var possibilities = ["H", "B", "R"]
	var new_type = possibilities[randi() % possibilities.size()]
	spawn_piece(new_type, tile)

func get_closest_tiles_to_player(tiles):
	var player_tile = GameManager.player.current_tile
	var closest : Array = []
	var min_dis = 100

	for tile in tiles:
		var x_dis = abs(player_tile.x-tile.x)
		var y_dis = abs(player_tile.y-tile.y)

		var dis = max(x_dis, y_dis)

		if dis < min_dis:
			min_dis = dis
			closest.clear()
			closest.append(tile)
		elif dis == min_dis:
			closest.append(tile)
			
	return closest
