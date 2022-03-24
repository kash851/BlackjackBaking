extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum State {STATE_ORDER = 0, STATE_OVEN = 1 , STATE_MIXER = 2,STATE_MOVEMENT = 3}
export(Array, Vector2) var positions

signal call
signal hit
signal start(order)
signal fail

var ovenOrders = []
var mixerOrders = []
var mixing = false
var mixWindow = false

var selection = 0

var currentState = State.STATE_MOVEMENT
#This is the current index of the positon array
var currentPos = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"onTimerTimeout")
	get_parent().connect("finished",self,"blackJackFinished")
	get_parent().connect("fail",self,"blackJackReset")
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
	print(OrderConstants.orders[order])
	if(OrderConstants.orders[order][1] == "Oven"):
		ovenOrders.append(order)
	else:
		assert(OrderConstants.orders[order][1] == "Mixer")
		mixerOrders.append(order)
	print(OrderConstants.orders[order][1] + " passed")
	print("OvenOrders: " + str(ovenOrders))

func movementState():
	if(Input.is_action_just_pressed("ui_right")):
		currentPos = (currentPos + 1) % 3
		self.global_position = positions[currentPos]
	elif(Input.is_action_just_pressed("ui_left")):
		for x in State:
			if State[x] == currentPos:
				currentState = State[x]
				mixing = currentState == State.STATE_MIXER
				if(currentState == State.STATE_MIXER or currentState == State.STATE_OVEN):
					randomize()
					$Timer.start(rand_range(15,20))
					print($Timer.time_left)

func orderState():
	var allOrders = mixerOrders + ovenOrders 	
	if(allOrders):
		if(Input.is_action_just_pressed("ui_right")):
			selection = selection % allOrders.size()
			print("Current Selection: " + str(allOrders[selection]))
		elif(Input.is_action_just_pressed("ui_left")):
			emit_signal("start",allOrders[selection])
			currentState = State.STATE_MOVEMENT

func ovenState():
	if(Input.is_action_just_pressed("ui_right")):
		emit_signal("hit")
	elif(Input.is_action_just_pressed("ui_left")):
		emit_signal("call")
		$Timer.stop()

func blackJackFinished(win):
	if(win):
		if(currentState == State.STATE_OVEN):
			ovenOrders.pop_front()
		else:
			assert(currentState == State.STATE_MIXER)
			mixerOrders.pop_front()
		$Timer.stop()
		currentState = State.STATE_MOVEMENT
	else:
		if currentState == State.STATE_MIXER:
			$Timer.start(rand_range(5,10))
			mixing = true
		else:
			$Timer.start(rand_range(15,20))

func mixerState():
	if(Input.is_action_just_pressed("ui_right")):
		emit_signal("hit")
	elif(Input.is_action_just_pressed("ui_left")):
		if(not mixWindow):
			print("Mixed Too SOON!")
			emit_signal("fail")
		else:
			emit_signal("call")
			$Timer.stop()

func onTimerTimeout():
	print("timer timed out lol")
	if(mixing):
		$Timer.start(5)
		mixWindow = true
		mixing = false
	else:
		emit_signal("fail")
		print("mixing was false")
		$Timer.start(rand_range(15,20))
		mixWindow = false

	
