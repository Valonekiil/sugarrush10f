extends Node2D
class_name AI

signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

export (PackedScene) var Bullet

onready var actor: KinematicBody2D = get_parent()
export var patrol_speed := 50

var current_state: int = State.PATROL setget set_state
var target: KinematicBody2D = null

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO
var patrol_timer: Timer

func _ready() -> void:
	patrol_timer = Timer.new()
	patrol_timer.wait_time = 5.0  # Ganti dengan waktu yang diinginkan
	patrol_timer.one_shot = true
	patrol_timer.connect("timeout", self, "_on_PatrolTimer_timeout")
	add_child(patrol_timer)

func _physics_process(delta: float) -> void:
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var direction = (patrol_location - global_position).normalized()
				actor_velocity = direction * patrol_speed
				actor.move_and_slide(actor_velocity)
				actor.rotation = actor_velocity.angle()
			else:
				actor_velocity = Vector2.ZERO
				patrol_timer.start()
				
		State.ENGAGE:
			if target != null:
				actor.look_at(target.global_position)
				var bullet = Bullet.instance()
				bullet.global_position = actor.get_node("BulletSpawnPosition").global_position
				bullet.rotation = actor.rotation
				get_parent().add_child(bullet)
			else:
				print("In the engage state but no target")


func set_state(new_state: int):
	if new_state == current_state:
		return

	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true

	current_state = new_state
	emit_signal("state_changed", current_state)

func _on_PatrolTimer_timeout() -> void:
	var patrol_range = 150
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false

func _on_DetectionZone_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		set_state(State.ENGAGE)
		target = body

func _on_DetectionZone_body_exited(body: Node) -> void:
	if target and body == target:
		set_state(State.PATROL)
		target = null
