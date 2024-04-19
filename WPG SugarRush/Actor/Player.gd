extends KinematicBody2D
class_name Player

const ENEMY_COLLISION_MASK_BIT = 2

signal player_fired_bullet(bullet, position, direction)
signal life_changed(Player_HP)
signal dead
signal set_bullet(bullet_now)
signal set_max(max_bullet)
signal rilot(yesnt)

export (PackedScene) var Bullet
export (int) var speed = 200
export (float) var shoot_cooldown = 3 #0.5
export (int) var dash_speed = 500 # Kecepatan dash
export (float) var dash_duration = 0.2 # Durasi dash dalam detik
export (float) var dash_cooldown = 30.0

onready var dash_cooldown_timer = $DashCD
onready var invincibility_timer = $IframeCD
onready var gun_node = $Sprite/GunNode
onready var end_of_gun = $Sprite/GunNode/EndOfGun
onready var gun_direction = $Sprite/GunNode/GunDirection
onready var health_stat = $Health
onready var shoot_timer = $ShootCD
onready var animated_sprite = $Sprite
onready var main = $"/root/Main"


var can_shoot = true
var max_ammo:int = 6
var ammo:int = max_ammo
var is_dashing = false
var dash_vector = Vector2.ZERO
var dash_timer = 0.0
var max_hp = 5
var hp = max_hp
var is_dead = false
var is_invincible = false
var original_collision_layer
var original_collision_mask
var PShots = 3
var Powered = true

func _ready()-> void:
	connect("life_changed",get_parent().get_node("UI/Life"),"on_player_life_changed")
	emit_signal("life_changed",max_hp)
	connect("dead",get_parent().get_node("UI/Life"),"_on_Player_Dead")
	connect("set_bullet",get_parent().get_node("UI/Stat"),"set_ammo")
	connect("set_max",get_parent().get_node("UI/Stat"),"set_max_ammo")
	connect("rilot",get_parent().get_node("UI/Stat"),"is_reload")
	$PlayerArea.connect("area_entered", self, "_on_player_area_entered")
	$PlayerArea.connect("area_exited", self, "_on_player_area_exited")
	original_collision_layer = collision_layer
	original_collision_mask = collision_mask
	emit_signal("rilot","no")
	$PShots.text = str(PShots)

func _process(delta: float):
	var movement_direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
		$Sprite.flip_h = true
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
		$Sprite.flip_h = false

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	# Menangani animasi berjalan
	if movement_direction != Vector2.ZERO:
		animated_sprite.play("Walk")
		if$WTimer.time_left <= 0:
			$Walk_sfx.pitch_scale = rand_range(0.8, 1.2)
			$Walk_sfx.play(4.65)
			$WTimer.start(0.46)
	else:
		animated_sprite.stop()
	
	var mouse_position = get_global_mouse_position()
	gun_node.look_at(mouse_position)

	# Periksa apakah mouse berada di sisi kanan atau kiri sprite player
	var player_to_mouse_vector = mouse_position - global_position
	var player_facing_vector = Vector2(1, 0).rotated(rotation)
	
	if player_to_mouse_vector.x < 0 and player_facing_vector.x > 0:
		$Sprite.flip_h = true
		$Sprite/GunNode.flip_v = true

	elif player_to_mouse_vector.x > 0 and player_facing_vector.x > 0:
		$Sprite.flip_h = false
		$Sprite/GunNode.flip_v = false
		
	var areas = $PlayerArea.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("Enemy") and not is_invincible:
			handle_hit()
			break

	if Input.is_action_just_pressed("dash") and not is_dashing:
		dash()

	if is_dashing:
		dash_timer += delta
		is_invincible = true
		$IframeCD.start(dash_duration)
		if dash_timer >= dash_duration:
			is_dashing = false
			dash_timer = 0.0
			$DashCD.start(dash_cooldown)

	if is_dashing:
		move_and_slide(dash_vector * dash_speed)
   
func _on_IframeCD_timeout():
	is_invincible = false
	collision_mask = original_collision_mask
	collision_layer = original_collision_layer  

func dash():
	is_dashing = true
	dash_vector = get_dash_direction()
	
	is_invincible = true
	invincibility_timer.start(dash_duration)
	collision_mask = 1
	collision_layer = 1

func get_dash_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	return direction.normalized()
		
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot") and can_shoot:
		shoot()
		
	if event.is_action_released("skill")and Powered:
		skill(Vector2(0,0))
		skill(Vector2(-12,25))
		skill(Vector2(12,-25))
		$Shot_sfx.play(0.30)
		PShots -= 1
		$PShots.text = str(PShots)
		
		if PShots == 0:
			$PShots.hide()
			Powered = false

	if event.is_action_released("reload") and ammo == 0 :
		$Rlot_sfx.play(0.31)
		emit_signal("rilot","yes")
		can_shoot = false  # Set can_shoot menjadi false setelah menembak
		shoot_timer.start(shoot_cooldown )  # Mulai Timer cooldown
		return
	if event.is_action_released("reload") and ammo < 6:
		$Rlot_sfx.play(1.41)
		emit_signal("rilot","yes")
		can_shoot = false  # Set can_shoot menjadi false setelah menembak
		shoot_timer.start(shoot_cooldown - 2)  # Mulai Timer cooldown

func skill(off: Vector2):
	if can_shoot:
		var bullet_instance = Bullet.instance()
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - gun_direction.global_position + off).normalized()
		emit_signal("player_fired_bullet", bullet_instance, gun_direction.global_position,direction)

func shoot():
	if can_shoot:
		if ammo == 0:
			emit_signal("rilot","yes")
			$Rlot_sfx.play(0.31)
			can_shoot = false  # Set can_shoot menjadi false setelah menembak
			shoot_timer.start(shoot_cooldown)  # Mulai Timer cooldown
			return
		var bullet_instance = Bullet.instance()
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - gun_direction.global_position).normalized()
		bullet_instance.set_direction(direction)
		emit_signal("player_fired_bullet", bullet_instance, gun_direction.global_position, direction)
		ammo -=1
		emit_signal("set_bullet",ammo)
		print("current ammo:"+ str(ammo))
		#$Shot_sfx.pitch_scale = rand_range(1.8, 0.4)
		$Shot_sfx.play(0.30)

func on_Player_Heal(heal: int):
	print("Signal Received")
	if hp < max_hp:
		hp += heal
		emit_signal("life_changed",hp)

func handle_hit():
	if not is_invincible:
		if not is_dead:
			hp -= 1
			emit_signal("life_changed", hp)
			animated_sprite.play("Hit")
			if hp <= 0:
				is_dead = true
				speed = 0
				yield(get_tree().create_timer(1.0), "timeout")
				self.hide()
				animated_sprite.play("Death")
				emit_signal("dead")
	
func _on_ShootCD_timeout():
	can_shoot = true 
	emit_signal("rilot","no")
	ammo =  max_ammo
	emit_signal("set_bullet",ammo)
	shoot_timer.stop()

func on_Player_Powered(Shots:int):
	PShots += Shots
	Powered = true
	$PShots.show()
	$PShots.text = str(Shots)

func _on_PlayerArea_area_entered(area):
	if area.is_in_group("Enemy") and not is_invincible:
		handle_hit()


func _on_PlayerArea_area_exited(area):
	if area.is_in_group("Enemy") and not is_invincible:
		pass
