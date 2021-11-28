extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



var target = 0
var playerCurrent = 0
var AICurrent = 0
var targetName = ""
var calling = false

signal finished(win)

var customer = preload("res://Scenes/Customer.tscn")

onready var player
onready var label
var keys = OrderConstants.orders.keys()

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("Label")
	player = get_node("Player")
	$Timer.start(5.0)
	$Timer.connect("timeout",self, "onTimerTimeout")
	player.connect("call", self, "blackJackCall")
	player.connect("hit", self, "blackJackHit")
	player.connect('start', self, "blackJackStart")
	player.connect('stop', self,"blackJackStop")
	blackJackReset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = ""
	label.text += "Order: " + targetName + "\n"
	label.text += "Target Number: " + str(target) + "\n"
	label.text += "Player Current Number: " + str(playerCurrent) + "\n"
	label.text += "AI Current Number: " + str(AICurrent) + "\n"  
	label.text += "Player State: " + player.State.keys()[player.currentState] + "\n"
func blackJackHit():
	if(not calling):
		print("hitting")
		var roll = randi() % 10 + 1 
		playerCurrent += roll
		if(playerCurrent > target):
			emit_signal("finished",false)
			blackJackStart(targetName)
			print("You lost :D")

func onTimerTimeout():
	var node = customer.instance()
	if(not get_node("Customer")):
		add_child(node)
		self.connect("finished", get_node("Customer"), "onFinished")
		print("customer added")
	$Timer.start(5.0)

func blackJackCall():
	print("calling")
	calling = true
	var difference = target - playerCurrent
	var roll
	while(target - AICurrent >= difference):
		roll = randi() % 10 + 1 
		AICurrent += roll
		yield(get_tree().create_timer(0.5), "timeout")
		if(AICurrent == playerCurrent): 
			continue
		if(AICurrent > target):
			print("You win :DDD")
			emit_signal("finished",true)
			blackJackReset()
			return
	if(AICurrent >  playerCurrent):
		print("You lost :D")
		emit_signal("finished",false)
		blackJackStart(targetName)
	else:
		print("You Win :DDD")
		emit_signal("finished",true)
		blackJackReset()
		



func blackJackStart(order):
	calling = false
	playerCurrent = 0
	AICurrent = 0
	target = OrderConstants.orders[order]
	targetName = order

func blackJackReset():
	if(label):
		yield(get_tree().create_timer(0.5),"timeout")
	calling = false
	randomize()
	target = OrderConstants.orders[keys[randi() % 3]]
	for x in keys:
		if OrderConstants.orders[x]  == target:
			targetName = x
	playerCurrent = 0
	AICurrent = 0


