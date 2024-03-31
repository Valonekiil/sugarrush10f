extends Area2D

onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
signal Healed(heal)

func _on_Kobis_body_entered(body:KinematicBody2D)-> void:
	emit_signal("Healed",1)
	collision_shape.set_deferred("disabled", true)
	queue_free()
