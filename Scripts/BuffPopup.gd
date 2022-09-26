extends Node2D

onready var tween : Tween = $Tween



func hp_pop(node : Node2D):
	global_position = node.global_position
	position.y = -16
	$Label.text = "+" + str(1) + " DMG" 
	tween.interpolate_property(self, "position",null, position + Vector2(0, -8), 1)
	tween.interpolate_property(self, "modulate", null, Color(0,0,0,0), 3)
	tween.start()