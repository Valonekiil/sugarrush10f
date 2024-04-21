extends Container




func _on_Next_B_pressed():
	$UI_tutor.current_tab += 1


func _on_Back_B_pressed():
	$UI_tutor.current_tab -=1


func _on_Exit_B_pressed():
	hide()
	get_tree().paused = !get_tree().paused
