extends KinematicBody2D

onready var HPBar = $HPBar

var max_health = 2
var health = max_health
var speed = 100
var motion = Vector2.ZERO
var player = null

func _ready():
	HPBar.max_value = max_health
	HPBar.value = health

func _process(delta):
	motion = Vector2.ZERO
	if player:
		motion = position.direction_to(player.position) * speed
	else:
		pass

	motion = move_and_slide(motion)
	
	if motion != Vector2.ZERO:
		$Sprite.play("walk")
	else:
		$Sprite.play("idle")

func handle_hit():
	health -= 1
	print(health)
	HPBar.value = health  # Memperbarui nilai HPBar sesuai dengan health yang tersisa
	if health <= 0:
		queue_free()

func _on_DetectionZone_body_entered(body):
	if body is Player:
		player = body

func _on_DetectionZone_body_exited(body):
	if body == Player:
		player = null

func _on_HitBox_body_entered(body):
	if body is Player:
		body.handle_hit()
