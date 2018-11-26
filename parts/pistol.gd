extends "res://parts/shooting_weapon.gd"

var laser_color = Color(1.0, .329, .298)

func _ready():
	initing()

func initing():
	shoot_impulse = 1500
	damage = 25
	ammo = "oo"
	magazineSize = 10
	magazine = 10
	fireColdown = 0.35
	reloadColdown = 1
	_name = "Pistol"
	sprite = load("res://images/pistol.png")

func _on_detecting_body_entered(body):
	if body.is_in_group("player"):
		player.set_weapon(self)
		queue_free()
