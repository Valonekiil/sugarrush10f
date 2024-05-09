extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)
signal summon_minions

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var ceri_scene = preload("res://Boss/Cherry.tscn")
onready var HPBar = $HPBar
onready var minion_spawn_positions = [
	$MinionSpawnPosition1,
	$MinionSpawnPosition2,
]

var max_health = 10
var health = max_health
var player = null
var fire_rate = 0.5
var is_invincible = false  # Variabel baru untuk mengontrol fase invincibility
var minions_alive = 0 
var has_summoned_minions = false

var state_machine
var current_state
var single_shot_timer = 0.0
var single_shot_interval = 1.0 / fire_rate
var spread_shot_timer = 0.0
var spread_shot_interval = 15.0
var spread_angle_range = PI / 3  # Rentang sudut untuk serangan spread (60 derajat)


enum States {SINGLE_SHOT, SPREAD_SHOT}

func _ready():
	state_machine = {
		States.SINGLE_SHOT: funcref(self, "single_shot_state"),
		States.SPREAD_SHOT: funcref(self, "spread_shot_state")
	}
	current_state = States.SINGLE_SHOT
	HPBar.max_value = max_health
	HPBar.value = health
	connect("summon_minions", self, "summon_minions")
	has_summoned_minions = false 

func _physics_process(delta):
	if player:
		state_machine[current_state].call_func(delta)

func handle_hit():
	if not is_invincible:
		health -= 1
		HPBar.value = health
		if health <= 0:
			queue_free()
			GameSetting.bos_killed = true
		elif health <= max_health / 2 and not has_summoned_minions:
			is_invincible = true
			has_summoned_minions = true
			current_state = States.SINGLE_SHOT  # Mengubah state menjadi SINGLE_SHOT
			emit_signal("summon_minions")

func single_shot_state(delta):
	single_shot_timer += delta
	if single_shot_timer >= single_shot_interval:
		single_shot_timer = 0.0
		shoot_single_bullet()

	spread_shot_timer += delta
	if spread_shot_timer >= spread_shot_interval and not is_invincible:  # Tambahkan kondisi untuk memeriksa fase invincibility
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

func summon_minions():
	var minion_scene = preload("res://Boss/Minion.tscn")  # Ganti dengan path menuju skrip Minion Anda
	for spawn_position in minion_spawn_positions:
		for i in range(5):
			var minion_instance = minion_scene.instance()
			minion_instance.connect("tree_exited", self, "_on_minion_died")
			get_parent().add_child(minion_instance)
			minion_instance.global_position = spawn_position.global_position
			yield(get_tree().create_timer(1.0), "timeout")
		minions_alive += 5

func _on_minion_died():
	minions_alive -= 1
	if minions_alive == 0:
		is_invincible = false 

func _on_DetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_DetectionZone_body_exited(body):
	if body == player:
		player = null
