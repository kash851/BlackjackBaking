extends Sprite


onready var timer = $Timer
onready var player

var randomOrder
signal giveOrder(order)


func _ready():
	player = get_parent().get_node("Player")
	self.connect("giveOrder",player,"onOrderReceived")
	timer.connect("timeout",self,"onTimerTimeout")
	randomOrder = OrderConstants.orders.keys()[randi() % 3]
	emit_signal("giveOrder", randomOrder)
	timer.start(rand_range(60,80))

func onFinished(win):
	if(win):
		print("customer satisfied!!! :DDDDDD")
		queue_free()

func onTimerTimeout():
	print("Customer that ordered " + randomOrder + " left!")
	queue_free()
