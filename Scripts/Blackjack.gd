extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target = 0
var playerCurrent = 0
var AICurrent = 0
var targetName = ""
var calling = false

onready var label
var keys = OrderConstants.orders.keys()

# Called when the node enters the scene tree for the first time.
func _ready():
	#Only doing this so that the 0.5 second delay doesn't happen
	randomize()
	target = OrderConstants.orders[keys[randi() % 3]]
	for x in keys:
		if OrderConstants.orders[x]  == target:
			targetName = x
	playerCurrent = 0
	AICurrent = 0
	label = get_node("Label")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = ""
	if Input.is_action_just_pressed("ui_right"):
		if(not calling):
			blackJackHit()
	elif Input.is_action_just_pressed("ui_left"):
		blackJackCall()
	label.text += "Order: " + targetName + "\n"
	label.text += "Target Number: " + str(target) + "\n"
	label.text += "Player Current Number: " + str(playerCurrent) + "\n"
	label.text += "AI Current Number: " + str(AICurrent) + "\n"  
func blackJackHit():
	print("hitting")
	var roll = randi() % 10 + 1 
	playerCurrent += roll
	if(playerCurrent > target):
		blackJackReset()
		print("You lost :D")

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
			blackJackReset()
			return
	if(AICurrent >  playerCurrent):
		print("You lost :D")
	else:
		print("You Win :DDD")
	blackJackReset()

func blackJackReset():
	yield(get_tree().create_timer(0.5),"timeout")
	calling = false
	randomize()
	target = OrderConstants.orders[keys[randi() % 3]]
	for x in keys:
		if OrderConstants.orders[x]  == target:
			targetName = x
	playerCurrent = 0
	AICurrent = 0
	label = get_node("Label")
