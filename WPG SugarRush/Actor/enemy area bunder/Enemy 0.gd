extends KinematicBody2D

onready var health_stat = $Health
onready var hit_box = $HitBox
onready var collision_shape = $CollisionShape2D
onready var HP = $HPBar
onready var main_node = $"/root/Main" 

signal progress

var speed = 100
var motion = Vector2.ZERO
var player = null
var patrol_points = []
var current_point_index = -1

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
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
	if motion != Vector2.ZERO:
		if$WTimerC.time_left <= 0:
			$Walk_sfx.pitch_scale = rand_range(0.8, 1.2)
			$Walk_sfx.play(4.20)
			$WTimerC.start(1.85)
	else:
		pass

func handle_hit():
	health_stat.health -= 20
	if health_stat.health == 0:
		main_node.jumlah_musuh -= 1
		emit_signal("progress")
		queue_free()
	HP.show()
	set_HP(health_stat.health)

func set_HP(health):
	HP.value = health_stat.health

func _on_DetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_DetectionZone_body_exited(body):
	if body == Player:
		player = null


func _ready():
	get_patrol_points()
	choose_random_point()
	HP.hide()
	connect("progress",get_parent().get_node("UI/Progres"),"_enemy_killed")

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
	var patrol_points_nodes = get_tree().get_nodes_in_group("patrolO")
	for point in patrol_points_nodes:
		patrol_points.append(point.global_position)

func choose_random_point():
	if patrol_points:
		current_point_index = randi() % patrol_points.size()


