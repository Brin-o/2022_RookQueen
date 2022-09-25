extends Node2D


export var x_scale = 1
var squash_speed = 0.3;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		x_scale += rand_range(-0.5, 0.5)

	x_scale = lerp(x_scale, 1, squash_speed)
	scale.x = x_scale
	scale.y = 1/x_scale
	pass


func take_dmg():
	x_scale = 2
