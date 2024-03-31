extends KinematicBody2D
class_name Player

signal player_fired_bullet(bullet, position, direction)
signal life_changed(Player_HP)
signal dead

export (PackedScene) var Bullet
export (int) var speed = 150

onready var end_of_gun = $EndOfGun
onready var gun_direction = $GunDirection
onready var health_stat = $Health

var max_hp: int = 3
var hp: int = max_hp
func _ready()-> void:
	connect("life_changed",get_parent().get_node("UI/Life"),"on_player_life_changed")
	emit_signal("life_changed",max_hp)
	connect("dead",get_parent().get_node("UI/Life"),"_on_Player_Dead")

func _process(delta: float):
	var movement_direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		shoot()
	
			
func shoot():
	var bullet_instance = Bullet.instance()
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - end_of_gun.global_position).normalized()
	emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position, direction)
	
func on_Player_Heal(heal: int):
	print("Signal Received")
	if hp < 3:
		hp += heal
		emit_signal("life_changed",hp)

func handle_hit():
	#health_stat.health -= 20
	#print("player hit, health: ", health_stat.health)
	hp -= 1
	emit_signal("life_changed",hp)
	if hp <= 0:
		self.hide()
		speed = 0 
		emit_signal("dead")
