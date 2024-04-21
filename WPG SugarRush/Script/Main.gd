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
onready var Kobis = $Kobis
onready var PU1 = $Power_Up
onready var EBar = $UI/Progres/ELbar
onready var Etx = $UI/Progres/PGbox/PGLeft
onready var Emax = $UI/Progres/PGbox/PGMax

func _ready():
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyup.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyup1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemydown.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemydown1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO2.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemyO3.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	PU1.connect("Powered",player,"on_Player_Powered")
	
	var kobis = load("res://Asset/Item/Kobis.tscn").instance()
	add_child(kobis)
	kobis.connect("Healed", player, "on_Player_Heal")
	
	var enemy_nodes = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemy_nodes:
		jumlah_musuh += 1
		enemy.connect("spawn_power_up", self, "_on_enemy_spawn_power_up") 
	var max_musuh:int = jumlah_musuh
	EBar.max_value = jumlah_musuh
	EBar.value = 0
	print(jumlah_musuh)
	Etx.text = str(jumlah_musuh)
	if Emax != null:
		Emax.text = str(max_musuh)

func _on_Fin_body_entered(body:KinematicBody2D):
	if body is Player:
		if jumlah_musuh <= 0:
			get_tree().change_scene("res://Ending.tscn")
		
func _on_enemy_spawn_power_up(power_up_instance):
	# Hubungkan sinyal "Powered" pada power_up_instance ke metode "on_Player_Powered" pada Player
	power_up_instance.connect("Powered", player, "on_Player_Powered")
