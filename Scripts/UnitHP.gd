extends Node2D


onready var piece = get_parent()

func _ready():
	if piece.type == "Player":
		$Label.visible = false
		$Shadow.visible = false

func _process(delta):
	$Label.text = str(piece.hp) + "hp" 
	$Shadow.text=  str(piece.hp) + "hp" 

