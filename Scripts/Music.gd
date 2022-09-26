extends AudioStreamPlayer


onready var selection = $"../UI/Selection"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	AudioServer.set_bus_effect_enabled(0, 0, selection.visible);

func _on_Music_finished():
	playing = true

