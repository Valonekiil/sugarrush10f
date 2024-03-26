extends KinematicBody2D

onready var health_stat = $Health
onready var hit_box = $HitBox

var speed = 100
var motion = Vector2.ZERO
var player = null
var patrol_points = []
var current_point_index = -1  # Mulai dengan indeks -1 untuk memilih titik acak pada awalnya

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
	else:
		patrol()
	
	motion = move_and_slide(motion)

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	print("enemy hit, health: ", health_stat.health)

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
	choose_random_point()  # Pilih titik patroli acak pada awalnya

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
