extends "res://mobs/Enemys.gd"

func _ready():
	initing()

func initing():
	connect("body_entered", self, "_on_Body2D_body_entered")
	hp = 100
	maxSpeed = 150
	_name = "Triangle"
	block_id = 0