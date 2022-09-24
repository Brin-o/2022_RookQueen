extends Node

class_name Board

var board : Array
export var offset = 50
export var dimension = 1
export (PackedScene) var tile_scene

export(PackedScene) var pawn
export(PackedScene) var bishop
export(PackedScene) var horse
export(PackedScene) var queen
export(PackedScene) var rook


var enemies_type = ["P", "p", "B", "b", "H", "h", "Q", "q", "R", "r"]
var enemies : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_board()
	read_file()
	GameManager.board = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func read_file():
	var file = File.new()
	file.open("res://test.txt", file.READ)
	var content = file.get_as_text()
	return content.split("\n")


func generate_board():
	var lines = read_file()
	var row = 0
	var column = 0
	board = []
	
	for line in lines:
		board.append([])
		for tile in line:
			var new_tile = tile_scene.instance()
			var tile_size = new_tile.get_node("Sprite/FloorSprite").texture.get_size().x * new_tile.get_node("Sprite/FloorSprite").scale.x + 4
			new_tile.position = Vector2(column * tile_size + 50,row * tile_size + 50)
			new_tile.pos = Vector2(row, column)
			new_tile.color = "White" if(row%2==0 and column%2!=0 or row%2!=0 and column%2==0) else "Black"
			if tile in enemies_type:
				new_tile.type = "F"
				spawn_piece(tile, new_tile.pos)
			else:
				new_tile.type = tile
			add_child(new_tile)
			board[row].append(new_tile)
			column += 1
		row += 1
		column = 0

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
		_:
			printerr("Wrong enemy character")

	piece.current_tile = pos
	piece.type = "Player" if tile == tile.to_lower() else "Enemy"
	if piece.type == "Enemy":
		enemies.append(piece)
	get_parent().call_deferred("add_child", piece)

func remove_from_enemies(enemy):
	enemies.erase(enemy)

func set_selectable_outline(var pos : Vector2, should_show : bool):
	var tile = get_tile(pos)
	tile.get_node("Selection/Attack").visible = should_show and tile.contains_enemy()
	tile.get_node("Selection/Move").visible = should_show and not tile.contains_enemy()