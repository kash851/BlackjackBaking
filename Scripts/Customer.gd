extends Sprite


onready var timer = $Timer
onready var player

var randomOrder
signal giveOrder(order)
var fails = 0

func _ready():
	randomize()
	player = get_parent().get_node("Player")
	self.connect("giveOrder",player,"onOrderReceived")
	timer.connect("timeout",self,"onTimerTimeout")
	randomOrder = OrderConstants.orders.keys()[randi() % OrderConstants.orders.size()]
	emit_signal("giveOrder", randomOrder)
	timer.start(rand_range(60,80))

func onFinished(win):
	if(win):
		print("customer satisfied!!! :DDDDDD")
		queue_free()

func onTimerTimeout():
	print("Customer that ordered " + randomOrder + " left!")
	for x in player.ovenOrders:
		if x == randomOrder:
			player.ovenOrders.remove(randomOrder)
	for y in player.mixerOrders:
		if y == randomOrder:
			player.mixerOrders.remove(randomOrder)
		fails += 1
	print("Fails: " + str(fails))
	if(fails >= 3):
		print("YOU LOSE FOR REAL")
		player.queue_free()
		get_tree().paused = true
	queue_free()
