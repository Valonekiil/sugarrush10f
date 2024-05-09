extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var health_stat = $Health
onready var hit_box = $HitBox
onready var collision_shape = $CollisionShape2D
onready var bullet_scene = preload("res://BulletJ.tscn")
onready var HP = $HPBar
onready var main_node = $"/root/Main" 

var speed = 50
var motion = Vector2.ZERO
var player = null
var patrol_points = []
var current_point_index = -1
var fire_rate = 0.5 # Tingkat tembakan dalam detik
var can_fire = true
var is_dead = false

signal progress
signal spawn_power_up(power_up_instance)

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
		handle_shooting(delta)
	else:
		patrol()
	
	var collision_info = move_and_collide(motion * delta)
	if collision_info:
		var collider = collision_info.collider
		if collider != self and collider.is_in_group("Enemy"):
			motion = motion.rotated(rand_range(-PI/4, PI/4))
			choose_random_point()
	
	# Atur flip sprite berdasarkan arah gerak
	if motion.x > 0:
		$Sprite.flip_h = false
	elif motion.x < 0:
		$Sprite.flip_h = true
	
	motion = move_and_slide(motion)
	if is_dead:
		$Sprite.play("Death")
	elif motion != Vector2.ZERO:
		$Sprite.play("Walk")
	else:
		$Sprite.play("Idle")

func handle_hit():
	health_stat.health -= 20
	HP.show()
	set_HP(health_stat.health)
	if health_stat.health == 0:	
		is_dead = true
		emit_signal("progress")
		speed = 0
		yield(get_tree().create_timer(1.0), "timeout")
		queue_free()
		#if main_node.jumlah_musuh != null:
			#main_node.jumlah_musuh -= 1
			
		var drop_chance = 0.5
		var random_number = randf()
		if random_number < drop_chance:
			var dropped_item = load("res://Asset/Item/Power_Up.tscn").instance()
			dropped_item.global_position = global_position
			get_parent().add_child(dropped_item)
			emit_signal("spawn_power_up", dropped_item)

func handle_shooting(delta):
	if player.is_in_group("Player") and can_fire:
		var bullet_instance = bullet_scene.instance()
		var direction = (player.get_global_transform().origin - end_of_gun.get_global_transform().origin).normalized()
		emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		can_fire = false
		yield(get_tree().create_timer(1.0 / fire_rate), "timeout")
		can_fire = true

func _on_DetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_DetectionZone_body_exited(body):
	if body == player:
		player = null

	
func _ready():
	get_patrol_points()
	choose_random_point()
	HP.hide()
	connect("progress",get_parent().get_node("UI/Progres"),"_enemy_killed_M_J")
 
func set_HP(health):
	HP.value = health_stat.health 

func _on_HitBox_body_entered(body):
	if body is Player:
		body.handle_hit()

func patrol():
	if patrol_points:
		var next_point = patrol_points[current_point_index]
		motion = position.direction_to(next_point) * speed
		
		if position.distance_to(next_point) < 10:
			choose_random_point()

func get_patrol_points():
	var patrol_points_nodes = get_tree().get_nodes_in_group("PatrolUp")
	for point in patrol_points_nodes:
		patrol_points.append(point.global_position)

func choose_random_point():
	if patrol_points:
		current_point_index = randi() % patrol_points.size()
