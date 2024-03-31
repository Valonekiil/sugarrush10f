extends KinematicBody2D

signal enemy_fired_bullet(bullet, position, direction)

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var health_stat = $Health
onready var hit_box = $HitBox
onready var collision_shape = $CollisionShape2D
onready var bullet_scene = preload("res://BulletJ.tscn")

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
		queue_free()
	print("enemy hit, health: ", health_stat.health)

func handle_shooting(delta):
	if can_fire:
		var bullet_instance = bullet_scene.instance()
		var direction = (player.global_position - end_of_gun.global_position).normalized()
		emit_signal("enemy_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
		can_fire = false
		yield(get_tree().create_timer(1.0 / fire_rate), "timeout")
		can_fire = true

func _on_DetectionZone_body_entered(body):
	if body is Player:
		print("Player entered")
		player = body

func _on_DetectionZone_body_exited(body):
	if body == player:
		print("Player exited")
		player = null

func _ready():
	hit_box.connect("body_entered", self, "_on_HitBox_body_entered")
	get_patrol_points()
	choose_random_point()
	collision_shape.connect("body_entered", self, "_on_body_entered")
 

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
	var patrol_points_nodes = get_tree().get_nodes_in_group("patrol_points")
	for point in patrol_points_nodes:
		patrol_points.append(point.global_position)

func choose_random_point():
	if patrol_points:
		current_point_index = randi() % patrol_points.size()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		avoid_timer = 1.0  # Durasi penghindaran tabrakan (dalam detik)
		avoid_direction = body.position.direction_to(position).rotated(randf() * PI - PI / 2)
