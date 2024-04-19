extends Area2D

onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
signal Powered(shots)


func _on_Power_Up_body_entered(body:KinematicBody2D)->void:
	if body is Player:
		emit_signal("Powered",5)
		collision_shape.set_deferred("disabled", true)
		
		queue_free()
