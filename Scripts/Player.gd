extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum State {STATE_ORDER = 0, STATE_OVEN = 1 , STATE_MIXER = 2,STATE_MOVEMENT = 3}
export(Array, Vector2) var positions

signal call
signal hit
signal start(order)
signal stop

var currentState = State.STATE_MOVEMENT
#This is the current index of the positon array
var currentPos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("finished",self,"blackJackFinished")
	self.global_position = positions[currentPos]
	pass # Replace with function body.



func _process(_delta):
	if(currentState == State.STATE_MOVEMENT):
		movementState()
	elif(currentState == State.STATE_ORDER):
		orderState()
	elif(currentState == State.STATE_OVEN):
		ovenState()
	elif(currentState == State.STATE_MIXER):
		mixerState()

func onOrderReceived(order):
	emit_signal("start",order)
	print(order + " passed")
	pass

func movementState():
	if(Input.is_action_just_pressed("ui_right")):
		currentPos = (currentPos + 1) % 3
		self.global_position = positions[currentPos]
	elif(Input.is_action_just_pressed("ui_left")):
		for x in State:
			if State[x] == currentPos:
				currentState = State[x]

func orderState():	
	pass

func ovenState():
	if(Input.is_action_just_pressed("ui_right")):
		emit_signal("hit")
	elif(Input.is_action_just_pressed("ui_left")):
		emit_signal("call")

func blackJackFinished(win):
	if(win):
		currentState = State.STATE_MOVEMENT

func mixerState():
	pass
	
	
