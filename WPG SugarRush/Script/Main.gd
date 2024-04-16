extends Node2D


var jumlah_musuh = 0

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemy = $EnemyJelly
onready var enemyup = $EnemyJelly2up
onready var enemyup1 = $EnemyJelly3up
onready var enemydown = $EnemyJellydown
onready var enemydown1 = $EnemyJellydown2
onready var enemyO = $EnemyJellyO
onready var enemyO1 = $EnemyJellyO2
onready var enemyO2 = $EnemyJellyO3
onready var enemyO3 = $EnemyJellyO4
onready var Kobis1 = $Kobis1
onready var Kobis2 = $Kobis2
onready var Kobis3 = $Kobis3

func _ready():
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	Kobis1.connect("Healed",player,"on_Player_Heal")
	Kobis2.connect("Healed",player,"on_Player_Heal")
	Kobis3.connect("Healed",player,"on_Player_Heal")
	enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyup.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyup1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemydown.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemydown1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO2.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO3.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	
	var enemy_nodes = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemy_nodes:
		jumlah_musuh += 1 
