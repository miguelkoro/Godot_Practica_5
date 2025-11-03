extends CanvasLayer
@onready var coins: Label = $Coins
@onready var height: Label = $Height


func update_score() -> void:
	coins.text = str(GameManager.points)
	height.text = str(GameManager.height)
	
