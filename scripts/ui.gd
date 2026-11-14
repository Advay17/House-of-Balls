extends Control

enum Team {
	Red,
	Blue
}
const EMPTY_HEART = preload("uid://cjdr4xr2k5oro")

@onready var main_text = $Text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ready_process() -> void:
	main_text.visible = true
	main_text.text = "Ready?"
	await get_tree().create_timer(2).timeout
	main_text.text = "Start!"
	
func start_process() -> void:
	await get_tree().create_timer(1).timeout
	main_text.visible = false

func set_health(team:int, health:int) -> void:
	for i in range(health+1,4):
		print("%s Hearts/Health %s" % ["Red" if team==Team.Red else "Blue", i])
		(get_node("%s Hearts/Health %s" % ["Red" if team==Team.Red else "Blue", i]) as TextureRect).texture = EMPTY_HEART

func end_game(team:int) -> void:
	main_text.text = "%s Wins!" % ("Blue" if team==Team.Red else "Red")
	main_text.visible = true
