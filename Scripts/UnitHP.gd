extends Node2D


onready var piece : BasePiece = get_parent()

func _ready():
	if piece.type == "Player":
		$Label.visible = false

func _process(delta):
	$Label.text = str(piece.hp) + "hp" 
