extends Node2D

var root_scene = null

var id = 0

func _ready():
	root_scene = get_tree().get_root().get_child(get_tree().get_root().get_child_count() - 1)
	#map.weapon_create(1, global_position, self)
	#for i in get_children().size():
		#if !get_child(i).is_in_group("color"):
			#print(get_child(i).position)

func _on_Timer_timeout():
	pass
