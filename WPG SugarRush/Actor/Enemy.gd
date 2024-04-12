extends KinematicBody2D

onready var health_stat = $Health
onready var hit_box = $HitBox
onready var collision_shape = $CollisionShape2D
onready var HP = $HPBar

var speed = 100
var motion = Vector2.ZERO
var player = null
var patrol_points = []
var current_point_index = -1
var avoid_timer = 0.0
var avoid_direction = Vector2.ZERO

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
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
	HP.show()
	set_HP(health_stat.health)

func set_HP(health):
	HP.value = health_stat.health

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
	HP.hide()

func _on_HitBox_body_entered(body):
	if body is Player:
		body.handle_hit()
	if body.is_in_group("Enemy"):
		avoid_timer = 1.0  # Durasi penghindaran tabrakan (dalam detik)
		avoid_direction = body.position.direction_to(position).rotated(randf() * PI - PI / 2)

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


