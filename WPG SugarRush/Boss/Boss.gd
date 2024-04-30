extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var ceri_scene = preload("res://Boss/Cherry.tscn")
onready var HPBar = $HPBar

var max_health = 10
var health = max_health
var player = null
var fire_rate = 0.5
var state_machine
var current_state
var single_shot_timer = 0.0
var single_shot_interval = 1.0 / fire_rate
var spread_shot_timer = 0.0
var spread_shot_interval = 15.0
var spread_angle_range = PI / 3  # Rentang sudut untuk serangan spread (60 derajat)

enum States {SINGLE_SHOT, SPREAD_SHOT}

func _ready():
	HPBar.max_value = max_health
	HPBar.value = health
	state_machine = {
		States.SINGLE_SHOT: funcref(self, "single_shot_state"),
		States.SPREAD_SHOT: funcref(self, "spread_shot_state")
	}
	current_state = States.SINGLE_SHOT

func _physics_process(delta):
	if player:
		state_machine[current_state].call_func(delta)

func handle_hit():
	health -= 1
	print(health)
	HPBar.value = health  # Memperbarui nilai HPBar sesuai dengan health yang tersisa
	if health <= 0:
		queue_free()

func single_shot_state(delta):
	single_shot_timer += delta
	if single_shot_timer >= single_shot_interval:
		single_shot_timer = 0.0
		shoot_single_bullet()
	
	spread_shot_timer += delta
	if spread_shot_timer >= spread_shot_interval:
		spread_shot_timer = 0.0
		current_state = States.SPREAD_SHOT

func spread_shot_state(delta):
	shoot_spread_bullets(8)
	current_state = States.SINGLE_SHOT
	spread_shot_timer = 0.0

func shoot_single_bullet():
	if player.is_in_group("Player"):
		var ceri_instance = ceri_scene.instance()
		var direction = (player.get_global_transform().origin - end_of_gun.get_global_transform().origin).normalized()
		emit_signal("enemy_fired_bullet", ceri_instance, end_of_gun.global_position, direction)

func shoot_spread_bullets(num_bullets):
	var player_direction = (player.get_global_transform().origin - end_of_gun.get_global_transform().origin).normalized()
	for i in range(num_bullets):
		var ceri_instance = ceri_scene.instance()
		var spread_direction = player_direction.rotated(rand_range(-spread_angle_range / 2, spread_angle_range / 2))
		emit_signal("enemy_fired_bullet", ceri_instance, end_of_gun.global_position, spread_direction)

func _on_DetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_DetectionZone_body_exited(body):
	if body == player:
		player = null
