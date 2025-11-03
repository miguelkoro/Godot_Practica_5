extends Node



var points: int = 0
var height: int = 0

func restart() -> void:
	points = 0
	height = 0
	update_gui()

func add_points(coin: int) -> void:
	points += coin
	update_gui()
	
func set_height(new_height: int) -> void:
	if(new_height > height):
		height = new_height
		update_gui()

func update_gui() -> void:
	var gui = get_tree().get_first_node_in_group("GUI")
	gui.update_score()
