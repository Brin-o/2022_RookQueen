extends Camera2D
class_name CameraCtrl

var target_rot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, target_rot, delta*8)