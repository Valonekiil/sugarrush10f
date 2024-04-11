extends Node2D

onready var bullet_manager = $BulletManager
onready var enemyup = $EnemyJelly2up
onready var enemyup1 = $EnemyJelly3up

func _ready():
	enemyup.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyup1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
