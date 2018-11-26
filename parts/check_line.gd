extends Area2D

var root_scene = null
var timer = null

var mas = []

var logic = 1

func _ready():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	timer = get_node("Timer")
	set_physics_process(false)

func _physics_process(delta):
	move()
	
func move():
	if logic == 2 or logic == 3:
		if logic == 2:
			timer.set_wait_time(0.25)
			timer.start()
		for i in map.connectLines[map.line].size():
			logic = 3
			var o = map.connectLines[map.line][i]
			o.global_translate(Vector2(0, -2.1))
			o.grid_apply(global_position, 3)

func _on_check_line_body_entered(body):
	if body.is_in_group("block"):
		mas.append(body)
	if mas.size() == 3:
		map.connectLines.append(mas)
		mas = []
		position.y -= 64
		timer.start()

func transfer_blocks(line):
	if logic == 1:
		for i in map.connectLines[map.line].size():
			var o = map.connectLines[map.line][i]
			o.position += Vector2(0, 64)
			o.set_collision_mask(17) 
			o.set_collision_layer(17)
		logic = 2
		set_physics_process(true)

func _on_Timer_timeout():
	if logic == 1:
		transfer_blocks(map.line)
	elif logic == 3:
		logic = 1
		timer.set_wait_time(0.5)
		set_physics_process(false)
		for i in map.connectLines[map.line].size():
			map.connectLines[map.line][i].position.y -= 0.5
		map.line += 1
		if map.line == 10:
			map.lvlStep = 1
			map.open_gate()