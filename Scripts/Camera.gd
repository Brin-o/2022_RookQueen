extends Camera2D
class_name CameraCtrl

var target_rot = 0
var target_z = 1 

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(rotation_degrees, target_rot, delta*8)
	zoom = lerp(zoom, Vector2.ONE*target_z, delta*14)



func lose():
	var z = rand_range(0.7,0.8)
	target_z = Vector2.ONE*z
	target_rot = rand_range(-2,25)
