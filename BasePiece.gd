extends Node2D

class_name BasePiece

signal finished_movement

var current_tile = Vector2(2,2)
var boardScene : Board
enum Type{Player, Enemy}
var type = Type.Player

# Called when the node enters the scene tree for the first time.
func _ready():
	boardScene = get_parent().get_node("Board")
	position = boardScene.board_position(current_tile)
	boardScene.set_tile_piece(current_tile, self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func can_move_to():
	assert(false, "Method not implemented!")

func move_to(var pos : Vector2):
	boardScene.set_tile_piece(current_tile, null)
	current_tile = pos
	position = boardScene.board_position(pos)
	boardScene.set_tile_piece(current_tile, self)

func _on_BasePiece_finished_movement():
	pass # Replace with function body.
