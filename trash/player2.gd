extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const MIN_ONAIR_TIME = 0.1
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 480
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2

var linear_vel = Vector2()
var onair_time = 0 #
var on_floor = false
var shoot_time = 99999 #time since last shot

var timer = null
var timerBool = false
var timerWork = false

var aim = null

var anim = ""
var sprite = null
var dir = "left"
var swap = false

var life = true

var weapon = null
var weapone_sprite = null
var weapone_for_rotate = null
var set_weapon = false
var weapon_sprite_offset = 0

var ammo = 150
var magazineLabel = null
var reloading = false

func _ready():
	sprite = get_node("Sprite")
	weapone_sprite = get_node("weapone_hands")
	timer = get_node("Timer")
	magazineLabel = get_node("magazine")

func _physics_process(delta):
	#sprite.modulate.a8 = 55
	onair_time += delta
	shoot_time += delta
	### MOVEMENT ###
	# Apply Gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and Slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect Floor
	if is_on_floor():
		onair_time = 0

	on_floor = onair_time < MIN_ONAIR_TIME

	### CONTROL ###

	# Horizontal Movement
	var target_speed = 0
	if Input.is_action_pressed("ui_a"):
		target_speed -=  1
	if Input.is_action_pressed("ui_d"):
		target_speed +=  1

	target_speed *= WALK_SPEED
	linear_vel.x = lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed("ui_space"):
		linear_vel.y = -JUMP_SPEED
	
	# Shooting
	
	if set_weapon and weapon.magazine != null:
		magazineLabel.set_text(str(weapon.magazine))
	else:
		magazineLabel.set_text(str(0))
	
	if Input.is_action_just_pressed("left_click"):
		if set_weapon and weapon.magazine > 0 and !reloading:
			weapon.magazine -= 1
			var bullet = preload("res://bullet.tscn").instance()
			aim = get_global_mouse_position()
			bullet.position = sprite.get_node("shoot").global_position
			var ang = (aim - position).angle()
			bullet.start(bullet.position, ang)
			#bullet.linear_velocity = Vector2(-sprite.scale.x * BULLET_VELOCITY, 0)
			#bullet.add_collision_exception_with(self) # don't want player to collide with bullet
			get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
			shoot_time = 0
			print(weapon.magazine)
			
		if weapon != null:
			if weapon.magazine == 0:
				if ammo >= 30:
					weapon.magazine += 30
					ammo -= 30
					reloading = true
				if ammo < 30 and ammo > 0:
					weapon.magazine += ammo
					ammo = 0
					reloading = true
					
	
	### ANIMATION ###
	var aim = get_global_mouse_position()
	var w_offset = { x = 0, y = 0 }
	
	if dir == "right":
		weapone_sprite.rotation = 0
		look_at(aim)
		var myAngle = rotation*57.3
		#print(abs(rotation), " ", abs(myAngle), " ", abs(cos(rotation)), " ", abs(cos(myAngle)))
		weapon_sprite_offset = rotation
		if rotation > 1.6:
			rotation = 1.6
		elif rotation < -1.6:
			rotation = - 1.6
		weapone_sprite.rotation = rotation
		weapone_sprite.scale.y = 1
		weapone_sprite.scale.x = -1
		rotation = 0
	else:
		weapone_sprite.rotation = 0
		look_at(aim)
		if rotation > -1.6 and rotation < 1.6:
			if rotation > -1.6 and rotation < 0:
				rotation = -1.6
			elif rotation > 0 and rotation < 1.6:
				rotation = 1.6
		weapone_sprite.rotation = rotation
		weapone_sprite.scale.y = -1
		weapone_sprite.scale.x = -1
		rotation = 0
	
	
	var new_anim = "stay"
	
	if set_weapon :
		new_anim = "weapon_stay"
	else:
		new_anim = "stay"
	
	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			weapone_sprite.position.x = 3
			#weapone_sprite.scale.x = 1
			#weapone_sprite.scale.y = 1
			if swap:
				dir = swap_dir()
				swap = false
			if set_weapon:
				new_anim = "weapon_run"
			else:
				new_anim = "run"
		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			weapone_sprite.position.x = -3
			weapone_sprite.scale.x = -1
			#weapone_sprite.scale.y = -1
			if !swap:
				dir = swap_dir()
				swap = true
			if set_weapon:
				new_anim = "weapon_run"
			else:
				new_anim = "run"
			
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed("ui_a") and not Input.is_action_pressed("ui_d"):
			sprite.scale.x = +1
		if Input.is_action_pressed("ui_d") and not Input.is_action_pressed("ui_a"):
			sprite.scale.x = -1

		if linear_vel.y < 0:
			if set_weapon:
				new_anim = "weapon_jump"
			else:
				new_anim = "jump"
		else:
			if set_weapon:
				new_anim = "weapon_fall"
			else:
				new_anim = "fall"

	if set_weapon and reloading:
		new_anim = "reloading"
		if !timerWork:
			timerWork = true
			timer.set_wait_time(0.7)
			timer.start()
			get_node("reload").visible = true
			weapone_sprite.visible = false
			if dir == "right":
				get_node("reload").scale.x = -1
			else:
				get_node("reload").scale.x = 1
			get_node("AnimationPlayer").play(new_anim)
		if timerBool:
			reloading = false
			timerBool = false
			timerWork = false
			get_node("reload").visible = false
			weapone_sprite.visible = true

	if new_anim != anim:
		anim = new_anim
		get_node("AnimationPlayer").play(anim)

func swap_dir():
	if dir == "left":
		return "right"
	else:
		return "left"

func _on_Timer_timeout():
	timerBool = true
