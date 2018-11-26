extends Particles2D

#var enemysColor = { 
   # triangle = ["4610b1", "715d99", "342a79", "7e6d93", "180a2a", "570a77", "bc2086", "9b1336"], 
   # square = ["c22121", "d36208", "bd040d", "e5be0f", "60571a", "807017", "ca3b0a", "c5c089"] , 
    #hexagon = ["051059", "283ab1", "949bce", "1ba1e3", "1a175c", "0e035d", "2e3354", "0c4dbd"] }
#ParticlesMaterial
#var gradients = { triangle = load("res://gradients/triangleGrad.tres"), square = load("res://gradients/squareGradt.tres"), hexagon = load("res://gradients/particlesmaterial2.tres") }

func _ready():
	initing()

func initing():
	set_emitting(true) 

#func set_exsplose_color(_name):
	#var gradi = get_process_material().get_color_ramp().get_gradient()
	#var colorNums = gradi.get_point_count()
	#if _name == "Triangle":
		#pass
	#elif _name == "Square":
		#pass
	#elif _name == "Hexagon":
		#pass
			
			

func _on_Timer_timeout():
	queue_free()
