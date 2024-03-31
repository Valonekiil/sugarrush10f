extends Node2D

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemy = $EnemyJelly
onready var Kobis = $Kobis


func _ready():
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	Kobis.connect("Healed",player,"on_Player_Heal")
	enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	
