extends TextureRect

export var p_name = "piece name here"
export(String, MULTILINE) var description = "piece description here"

export var map_piece = "p"
export var bonus_hp : int = 2

onready var ui_selection : UI_Selection = get_parent().get_parent()

var hovered 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	visible = GameManager.next_player_piece != map_piece
	if GameManager.level.num == 4 and map_piece == "h":
		visible = false
		hovered = false

	if hovered:
		rect_position.y = lerp(rect_position.y, -10, delta*10)
	else:
		rect_position.y = lerp(rect_position.y, 0, delta*14)

	if Input.is_action_just_pressed("mouseL") and hovered:
		hovered = false
		GameManager.upgrade_piece(map_piece, bonus_hp)
		yield(GameManager, "selected_new_piece")

	pass

func _on_Piece_mouse_entered():
	hovered = true
	ui_selection.p_name = p_name
	ui_selection.p_description = description


func _on_Piece_mouse_exited():
	hovered = false
	ui_selection.default_txt()
