extends TextureRect

export var p_name = "piece name here"
export(String, MULTILINE) var description = "piece description here"

export var map_piece = "p"
export var bonus_hp : int = 2

onready var ui_selection : UI_Selection = get_parent().get_parent()

var hovered 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _process(delta):
	if(hovered):
		rect_position.y = lerp(rect_position.y, -10, delta*10)
	else:
		rect_position.y = lerp(rect_position.y, 0, delta*14)

	if Input.is_action_just_pressed("mouseL") and hovered:
		GameManager.upgrade_piece(map_piece, bonus_hp)

	pass

func _on_Piece_mouse_entered():
	hovered = true
	ui_selection.p_name = p_name
	ui_selection.p_description = description


func _on_Piece_mouse_exited():
	hovered = false
	ui_selection.default_txt()
