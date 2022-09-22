extends Node

class_name Board

var board : Array
export var offset = 50
export var dimension = 1
export (PackedScene) var tile_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_board()
	read_file()


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
			var tile_size = new_tile.get_node("FloorSprite").texture.get_size().x * new_tile.get_node("FloorSprite").scale.x
			new_tile.position = Vector2(column * tile_size + 50,row * tile_size + 50)
			new_tile.type = tile
			add_child(new_tile)
			board[row].append(new_tile)
			column += 1
		row += 1
		column = 0

func board_position(pos):
	assert(is_position_inbounds(pos), "You were trying to access an out of bounds position")
	return board[pos.x][pos.y].position


func is_position_inbounds(new_pos: Vector2):
	if new_pos.x < 0 or new_pos.y < 0:
		return false

	if new_pos.x >= board.size():
		return false

	if new_pos.y >= board[new_pos.x].size():
		return false
		
	return true

func is_steppable(new_pos: Vector2):
	var inbounds = is_position_inbounds(new_pos)

	if not inbounds:
		return false

	return board[new_pos.x][new_pos.y].is_walkable()

