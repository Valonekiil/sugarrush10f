extends StaticBody2D
onready var s = $desfx
signal sef
func _on_Barrel_area_entered(area):
	if area.is_in_group("bullet"):
		s.play()
		var kobis = load("res://Asset/Item/Kobis.tscn").instance()
		kobis.global_position = area.global_position
		var player = get_node("/root/Main/Player") # Ganti dengan path yang sesuai
		kobis.connect("Healed", player, "on_Player_Heal")
		get_parent().add_child(kobis)
		emit_signal("sef")
		queue_free()

