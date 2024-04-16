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
var avoid_timer = 0.0
var avoid_direction = Vector2.ZERO
var fire_rate = 0.5 # Tingkat tembakan dalam detik
var can_fire = true


func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
		handle_shooting(delta)
	else:
		patrol()
	
	if avoid_timer > 0:
		avoid_timer -= delta
		motion += avoid_direction * speed
	
	motion = move_and_slide(motion)

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		main_node.jumlah_musuh -= 1
		queue_free()
	HP.show()
	set_HP(health_stat.health)

func handle_shooting(delta):
	if can_fire:
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
	if body == Player:
		player = null

	
func _ready():
	hit_box.connect("body_entered", self, "_on_HitBox_body_entered")
	get_patrol_points()
	choose_random_point()
	collision_shape.connect("body_entered", self, "_on_body_entered")
	HP.hide()
 
func set_HP(health):
	HP.value = health_stat.health 

func _on_HitBox_body_entered(body):
	if body is Player:
		body.handle_hit()
	if body.is_in_group("Enemy"):
		avoid_timer = 0.5  # Durasi penghindaran tabrakan (dalam detik)
		avoid_direction = body.position.direction_to(position).rotated(randf() * PI - PI / 2)

func patrol():
	if patrol_points:
		var next_point = patrol_points[current_point_index]
		motion = position.direction_to(next_point) * speed
		
		if position.distance_to(next_point) < 10:
			choose_random_point()

func get_patrol_points():
	var patrol_points_nodes = get_tree().get_nodes_in_group("patrolO")
	for point in patrol_points_nodes:
		patrol_points.append(point.global_position)

func choose_random_point():
	if patrol_points:
		current_point_index = randi() % patrol_points.size()
