extends Area2D

export (int) var speed = 5

onready var kill_timer = $KillTimer

var direction := Vector2.ZERO

func _ready() -> void:
	kill_timer.start()
	connect("body_entered", self, "_on_body_entered")

func _physics_process(delta: float):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation = direction.angle()

func _on_KillTimer_timeout():
	queue_free()

func _on_body_entered(body):
	if body is Player:  # Periksa apakah objek yang bertabrakan adalah pemain
		body.handle_hit()
		queue_free()
