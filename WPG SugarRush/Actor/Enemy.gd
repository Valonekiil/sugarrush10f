extends KinematicBody2D

onready var health_stat = $Health
onready var hit_box = $HitBox

var speed = 100
var motion = Vector2.ZERO
var player = null

func _physics_process(delta):
	motion = Vector2.ZERO
	
	if player:
		motion = position.direction_to(player.position) * speed
		motion = move_and_slide(motion)

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	print("enemy hit, health: ", health_stat.health)

func _on_DetectionZone_body_entered(body):
	# Periksa apakah objek yang memasuki DetectionZone adalah instance dari player
	if body is Player:
		print("Player entered")
		player = body
	else:
		print("Non-player object entered")

func _on_DetectionZone_body_exited(body):
	# Periksa apakah objek yang keluar dari DetectionZone adalah instance dari player
	if body == player:
		print("Player exited")
		player = null
	else:
		print("Non-player object exited")


func _ready():
	hit_box.connect("body_entered", self, "_on_HitBox_body_entered")

func _on_HitBox_body_entered(body):
	if body is Player:
		body.handle_hit()
