extends CanvasLayer

@export_file("*.tscn") var next_scene: String
@onready var button = $Button
@onready var label = $Control/Label
@onready var loading = $loading
@onready var touch_screen_button = $TouchScreenButton
@onready var animation_player = $Control/AnimationPlayer

func _ready():
	button.visible = false
	label.visible = false
	ResourceLoader.load_threaded_request(next_scene)

func _process(delta):
	if ResourceLoader.load_threaded_get_status(next_scene) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(3).timeout
		button.visible = true
		label.visible = true
		loading.visible=false
		animation_player.play("label")
		animation_player.play("new_animation_2")




func _on_button_pressed():
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene)
	get_tree().change_scene_to_packed(new_scene)


func _on_touch_screen_button_pressed():
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene)
	get_tree().change_scene_to_packed(new_scene)
