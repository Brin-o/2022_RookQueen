extends Node

# Declare member variables here. Examples:
var board
export var offset = 50

export var dimension = 1
export (PackedScene) var tile_scene



# Called when the node enters the scene tree for the first time.
func _ready():
	generate_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func generate_board():

	board = []
	
	for i in dimension:
		board.append([])
		for j in dimension:
			var new_tile = tile_scene.instance()
			var tile_size = new_tile.get_node("WhiteSprite").texture.get_size().x * new_tile.get_node("WhiteSprite").scale.x
			new_tile.position = Vector2(i * tile_size + 50,j * tile_size + 50)
			new_tile.type = (i+j)%2 + 1
			add_child(new_tile)
			board[i].append(new_tile) # Set a starter value for each position

