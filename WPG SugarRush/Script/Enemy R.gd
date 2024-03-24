extends KinematicBody2D

export (PackedScene) var Bullet

onready var health_stat = $Health
onready var ai = $AIr


func _ready():
	ai.set_state(ai.State.PATROL)

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
	print("enemy hit", health_stat)
