extends Node2D

var jumlah_musuh = 0

onready var bullet_manager = $BulletManager
onready var boss = $Boss
onready var player = $Player
onready var enemy1 = $EnemyJellyOut
onready var enemy2 = $EnemyJellyOut2
onready var EBar = $UI/Progres/ELbar
onready var Etx = $UI/Progres/PGbox/PGLeft
onready var Emax = $UI/Progres/PGbox/PGMax
onready var PGR = $UI/Progres
onready var c_an =$UI/Map
onready var c_tx =$UI/Map/Cur_Map

func _ready():
	BgmTes.play_bgm(2)
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemy1.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemy2.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	boss.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
	PGR.connect("bos",self,"Block_loss")
	var enemy_nodes = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemy_nodes:
		jumlah_musuh += 1
		enemy.connect("spawn_power_up", self, "_on_enemy_spawn_power_up") 
	var max_musuh:int = jumlah_musuh
	EBar.max_value = max_musuh
	EBar.value = 0
	print(jumlah_musuh)
	Etx.text = str(jumlah_musuh)
	if Emax != null:
		Emax.text = str(max_musuh)
		
	
	$Boss/layer/HPBar.hide()
	c_tx.text = "Factory"
	c_an.play("Show")

func _on_enemy_spawn_power_up(power_up_instance):
	power_up_instance.connect("Powered", player, "on_Player_Powered")

func Block_loss():
	$Block/Block_boss.disabled = true

func _on_HP_Boss_body_entered(body):
	if body is Player:
		$Boss/layer/HPBar.show()
		$Block/Block_boss.disabled = false


func _on_Fin_body_entered(body):
	if body is Player:
		if jumlah_musuh <= 0:
			get_tree().change_scene("res://Ending.tscn")
