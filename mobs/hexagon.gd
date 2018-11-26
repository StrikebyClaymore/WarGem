extends "res://mobs/Enemys.gd"

var laser = preload("res://parts/blue_laser.tscn")
var shootLogic = false

func _ready():
	initing()

func initing():
	connect("body_entered", self, "_on_Body2D_body_entered")
	hp = 160
	maxSpeed = 200
	_name = "Hexagon"
	block_id = 2

func blast_shoot(target):
	if !shootLogic:
		shootLogic = true
		var las = laser.instance()
		var imp = (target.position - self.position).normalized()
		las.position = self.position
		las.other = self
		root_scene.add_child(las)
		las.rotation = imp.angle()
		las.apply_impulse(Vector2(), imp*las.shoot_impulse)