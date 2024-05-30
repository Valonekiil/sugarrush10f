extends AudioStreamPlayer

const mainM_song = preload("res://Audio/BGM/Complete1.wav")
const L1_song = preload("res://Audio/BGM/Sid - Retro fabric Cassette - Chill - 24 Mei 2024 18.27.wav")
const L2_song = preload("res://Audio/BGM/Sid - pabrik 30 Mei 2024 18.54.wav")

func play_music(music: AudioStream):
	if stream == music:
		return
	stream = music
	play()
	

func play_bgm(v:int):
	if v == 1:
		play_music(L1_song)
		return
	if v == 2:
		play_music(L2_song)
		return
	else:
		play_music(mainM_song)
