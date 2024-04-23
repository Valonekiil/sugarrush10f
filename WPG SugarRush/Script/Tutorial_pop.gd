extends CanvasLayer

signal pau


func _on_Next_B_pressed():
	$UI_tutor.current_tab += 1


func _on_Back_B_pressed():
	$UI_tutor.current_tab -=1





func _on_Exit_B_pressed():
	#emit_signal("pau")
	#print("signal out")
	hide()
