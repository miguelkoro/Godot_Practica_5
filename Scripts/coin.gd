extends Area2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		animated.play("destroy")
		audio.play()
		animation_player.stop()
		if is_in_group("Coin_Big"):
			GameManager.add_points(5)
		elif is_in_group("Coin_Small"):
			GameManager.add_points(1)
		

func _on_animated_sprite_2d_animation_finished() -> void:	
	#queue_free()
	visible = false
	monitoring = false
	
func restart() -> void:
	await  get_tree().create_timer(0.5).timeout
	visible = true
	monitoring = true
	animated.play("idle")
	animation_player.play("idle")
