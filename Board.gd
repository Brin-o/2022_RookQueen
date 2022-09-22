extends Node

var board
export var offset = 50
export var dimension = 1
export (PackedScene) var tile_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_board()
	read_file()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
			board[row].append(new_tile) # Set a starter value for each position
			column += 1
		row += 1
		column = 0

func read_file():
	var file = File.new()
	file.open("res://test.txt", file.READ)
	var content = file.get_as_text()
	return content.split("\n")

