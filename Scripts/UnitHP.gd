extends Node2D


onready var piece : BasePiece = get_parent()

func _process(delta):
	$Label.text = str(piece.hp) + "hp" 
