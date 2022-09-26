extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var cursorpos = $CursorSprite.position
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_viewport().get_mouse_position()
	if Input.is_action_pressed("mouseL"):
		$CursorSprite.position = $Shadow.position
	else:
		$CursorSprite.position = cursorpos
