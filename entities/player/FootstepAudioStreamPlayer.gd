extends AudioStreamPlayer

func play_footstep_audio():
	if !playing:
		stop()
		
	play()
