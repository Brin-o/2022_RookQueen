extends Node2D


onready var piece = get_parent()

func _process(delta):
	$Label.text = str(piece.hp) + "hp" 
