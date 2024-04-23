extends Node2D

var jumlah_musuh = 0

onready var bullet_manager = $BulletManager
onready var player = $Player
onready var enemy = $EnemyJelly
onready var PU1 = $Power_Up
onready var EBar = $UI/Progres/ELbar
onready var Etx = $UI/Progres/PGbox/PGLeft
onready var Emax = $UI/Progres/PGbox/PGMax


func _ready():
	player.connect("player_fired_bullet", bullet_manager, "handle_bullet_spawned")
	enemy.connect("enemy_fired_bullet", bullet_manager, "handle_bullet_spawned")
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
	
	if GameSetting.tutor == false:
		
		$Tutorial_pop.show()
		#get_tree().paused = !get_tree().paused
		
		GameSetting.tutor = true
		
	else:
		pass
	
			
func _on_enemy_spawn_power_up(power_up_instance):
	power_up_instance.connect("Powered", player, "on_Player_Powered")


func _on_MC_Skip_Btn_pressed():
	get_tree().paused = !get_tree().paused
	$Area2D/musuh_conf.hide()



func _on_musuh_conf_col_body_entered(body):
	get_tree().paused = !get_tree().paused
	
func _on_Exit_B_pressed():
	hide()
	print("Value: ",get_tree().paused)
