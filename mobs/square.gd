extends "res://mobs/Enemys.gd"

func _ready():
	initing()

func initing():
	connect("body_entered", self, "_on_Body2D_body_entered")
	hp = 200
	maxSpeed = 120
	_name = "Square"
	block_id = 1