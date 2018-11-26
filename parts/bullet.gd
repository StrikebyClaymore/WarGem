extends RigidBody2D

var lifeTime = 5
var timer = null
var damage = 0

var _name = "Bullet"
var id

func _ready():
	start_functions()

func _physics_process(delta):
	if timer.get_time_left() < 2:
		modulate.a8 = timer.get_time_left()*100
		

func start_functions():
	add_scene_nodes()
	initing()

func add_scene_nodes():
	timer = get_node("Timer")

func initing():
	timer.set_wait_time(lifeTime)
	timer.start()

func _on_Timer_timeout():
	queue_free()

func _on_bullet_body_entered(body):
	print("as")
