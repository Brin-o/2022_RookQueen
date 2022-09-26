extends Control
class_name UI_Selection

const DEFAULT_N="PROMOTION"
const DEFAULT_D="Select a piece to upgrade your character to."

var p_name 
var p_description

# Called when the node enters the scene tree for the first time.
func _ready():
	default_txt()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$PieceName.text = p_name
	$PieceDescription.text = p_description

func default_txt():
	p_name = DEFAULT_N
	p_description = DEFAULT_D

func flavour_text(t):
	$StoryText.text = t