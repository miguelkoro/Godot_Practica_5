extends Camera2D
@onready var audio_music: AudioStreamPlayer2D = $AudioStream_Music
@onready var player: CharacterBody2D = $"../Player"
@export var smooth_speed: float = 5.0
func _process(delta: float) -> void:
	#Solo se sigue la pos Y del jugador
	var target_position = Vector2(position.x, player.position.y)
	# Suavizar el movimiento de la camara
	position = position.lerp(target_position, smooth_speed * delta)


func _on_audio_stream_music_finished() -> void:
	audio_music.play()
