extends Control

signal close_request
signal anim_play_quit
signal setting_request

@onready var panel: Panel = $panel
@onready var close_button: Button = $panel/vboxcontainer/close/button
@onready var setting_button: Button = $panel/vboxcontainer/setting/button
@onready var quit_button: Button = $panel/vboxcontainer/quit/button

func _ready() -> void:
	visible = false
	position.y = -648
	close_button.pressed.connect(close_btn_pressed)
	quit_button.pressed.connect(quit_btn_pressed)
	setting_button.pressed.connect(setting_btn_pressed)

func close_btn_pressed() -> void:
	close_request.emit()

func setting_btn_pressed() -> void:
	setting_request.emit()

func quit_btn_pressed() -> void:
	get_window().borderless = true # failsafe
	Global.saving()
	anim_play_quit.emit()
	await get_tree().create_timer(1).timeout
	get_tree().quit()
