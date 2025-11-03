extends Area2D

@export var speed: float = 18.0
@export var delay: float = 3.0

var tween: Tween

var start: bool = false

func _ready() -> void:
	await  get_tree().create_timer(delay).timeout
	start = true

func _physics_process(delta: float) -> void:
	if start:
		position.y -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.die()
		await  get_tree().create_timer(0.5).timeout		
		restart()

func restart() -> void:	
	#position.y = 0
	await  get_tree().create_timer(0.5).timeout		
	start = false
	if tween:
		tween.kill()  # cancelamos si había otro tween activo
	tween = create_tween()
	tween.tween_property(self, "position:y", 0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await  get_tree().create_timer(delay+2).timeout
	start = true
