extends KinematicBody2D
class_name Player

signal player_fired_bullet(bullet, position, direction)
signal life_changed(Player_HP)
signal dead

export (PackedScene) var Bullet
export (int) var speed = 200
export (float) var shoot_cooldown = 0.5

onready var gun_node = $Sprite/GunNode
onready var end_of_gun = $Sprite/GunNode/EndOfGun
onready var gun_direction = $Sprite/GunNode/GunDirection
onready var health_stat = $Health
onready var shoot_timer = $ShootCD
onready var animated_sprite = $Sprite
onready var fin : Area2D = get_node("/root/Main/Fin")
onready var main = $"/root/Main"

var can_shoot = true


var max_hp: int = 5
var hp: int = max_hp
var is_dead = false

func _ready()-> void:
	connect("life_changed",get_parent().get_node("UI/Life"),"on_player_life_changed")
	emit_signal("life_changed",max_hp)
	connect("dead",get_parent().get_node("UI/Life"),"_on_Player_Dead")
	print(fin)

func _process(delta: float):
	var movement_direction := Vector2.ZERO

	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
		$Sprite.flip_h = true
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
		$Sprite.flip_h = false

	movement_direction = movement_direction.normalized()
	move_and_slide(movement_direction * speed)

	# Menangani animasi berjalan
	if movement_direction != Vector2.ZERO:
		animated_sprite.play("Walk")
	else:
		animated_sprite.stop()
	
	var mouse_position = get_global_mouse_position()
	gun_node.look_at(mouse_position)

	# Periksa apakah mouse berada di sisi kanan atau kiri sprite player
	var player_to_mouse_vector = mouse_position - global_position
	var player_facing_vector = Vector2(1, 0).rotated(rotation)
	
	if player_to_mouse_vector.x < 0 and player_facing_vector.x > 0:
		$Sprite.flip_h = true
		$Sprite/GunNode.flip_v = true

	elif player_to_mouse_vector.x > 0 and player_facing_vector.x > 0:
		$Sprite.flip_h = false
		$Sprite/GunNode.flip_v = false
		
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot") and can_shoot:
		shoot()
		$Shot_sfx.play()
			
	if event.is_action_released("skill"):
		skill(Vector2(0,0))
		skill(Vector2(-12,25))
		skill(Vector2(12,-25))

func skill(off: Vector2):
	if can_shoot:
		var bullet_instance = Bullet.instance()
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - end_of_gun.global_position + off).normalized()
		emit_signal("player_fired_bullet", bullet_instance, end_of_gun.global_position,direction)

func shoot():
	if can_shoot:
		var bullet_instance = Bullet.instance()
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - gun_direction.global_position).normalized()
		bullet_instance.set_direction(direction)
		emit_signal("player_fired_bullet", bullet_instance, gun_direction.global_position, direction)
		can_shoot = false  # Set can_shoot menjadi false setelah menembak
		shoot_timer.start(shoot_cooldown)  # Mulai Timer cooldown


func on_Player_Heal(heal: int):
	print("Signal Received")
	if hp < max_hp:
		hp += heal
		emit_signal("life_changed",hp)

func handle_hit():
	if not is_dead:
		hp -= 1
		emit_signal("life_changed", hp)
		animated_sprite.play("Hit")  # Memainkan animasi "Hit"
		if hp <= 0:
			is_dead = true
			speed = 0
			yield(get_tree().create_timer(1.0), "timeout")  # Jeda 1 detik sebelum menghilangkan karakter
			self.hide()
			animated_sprite.play("Death")  # Memainkan animasi "Death"
			emit_signal("dead")

func _on_Sprite_animation_finished():
	pass
	
func _on_ShootCD_timeout():
	can_shoot = true 


func _on_Fin_area_entered(area):
	if main.jumlah_musuh == 0:
		get_tree().change_scene("res://CreditM.tscn")
	else:
		print("Musuh Tersisa =", main.jumlah_musuh)
