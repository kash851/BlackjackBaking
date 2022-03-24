extends ColorRect

onready var timer 
# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_parent().get_node("Player/Timer")
	pass # Replace with function body.



func _process(delta):
	rect_size = Vector2(timer.get_time_left() * 10, 20)
