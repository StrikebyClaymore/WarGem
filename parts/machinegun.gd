extends "res://parts/shooting_weapon.gd"



func _ready():
	initing()
	
func initing():
	shoot_impulse = 2000
	damage = 45
	ammo = 600
	magazineSize = 30
	magazine = 30
	fireColdown = 0.1
	reloadColdown = 1.5
	_name = "Machinegun"
	sprite = load("res://images/machingun.png")

func _on_detecting_body_entered(body):
	if body.is_in_group("player"):
		player.set_weapon(self)
		queue_free()
