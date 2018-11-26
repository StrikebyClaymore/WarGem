extends Area2D

var root_scene = null

var id = 0

var block = preload("res://parts/block.tscn")
var blockCell = []
var unactiveCell = []
var activeBlock = false
var blocks = []
var use_open = true

func _ready():
	start_processes()

func add_nodes():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)

func start_processes():
	add_nodes()
	set_ids()
	add_classes()

func _physics_process(delta):
	if use_open:
		use_open = false
		get_node("Timer").start()
		spawn_block()

func set_ids():
	for i in root_scene.get_children().size():
		if root_scene.get_child(i) != null and root_scene.get_child(i).is_in_group("block_spawn"):
			id += 1

func add_classes():
	if self.id == 1:
		var b = block.instance()
		for i in b.get_children().size():
			if b.get_child(i).group == "block":
				blocks.append(b.get_child(i))

func create_block(num):
	var b = blocks[num].duplicate()
	b.position = position
	blockCell.append(b)

func spawn_block():
	if !activeBlock and blockCell != []:
	#	if blockCell[0].active:
		activeBlock = true
		root_scene.add_child(blockCell[0])
		blockCell.pop_front()

func _on_Timer_timeout():
	use_open = true
