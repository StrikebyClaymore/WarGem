extends RigidBody2D

var _name = "Bullet"
var other = null
var damage = 20
var shoot_impulse = 1000
var lifeTime = 2

func _ready():
	get_node("Timer").set_wait_time(lifeTime)
	get_node("Timer").start()

func destroy():
	
	get_node("Timer").set_wait_time(0.1)
	get_node("Timer").start()


func _on_Timer_timeout():
	if other != null and other.is_in_group("hexagon"):
		other.shootLogic = false
	queue_free()
