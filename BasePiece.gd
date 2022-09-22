extends Node2D

class_name BasePiece

var pressed = false
var current_tile = Vector2(1,0)
var boardScene : Board

# Called when the node enters the scene tree for the first time.
func _ready():
	boardScene = get_parent().get_node("Board")
	position = boardScene.board_position(current_tile)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		pressed = not pressed

	if pressed:
		can_move_to()

func can_move_to():
	assert(false, "Method not implemented!")
