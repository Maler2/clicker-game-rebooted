extends Control

signal close_request_setting
signal anim_play_restart
signal audio_request
signal other_request

@onready var panel: Panel = $panel
@onready var back_button: Button = $panel/vboxcontainer/close/button
@onready var reset_button: Button = $panel/vboxcontainer/reset/button
@onready var audio_button: Button = $panel/vboxcontainer/audio/button
@onready var other_button: Button = $panel/vboxcontainer/other/button

func _ready() -> void:
	visible = false
	panel.self_modulate = Color(1, 1, 1, 0.5)
	position.y = -720
	back_button.pressed.connect(back_btn_pressed)
	reset_button.pressed.connect(reset_btn_pressed)
	audio_button.pressed.connect(audio_btn_pressed)
	other_button.pressed.connect(other_btn_pressed)

func back_btn_pressed() -> void:
	close_request_setting.emit()

func reset_btn_pressed() -> void:
	get_window().borderless = true # failsafe
	anim_play_restart.emit()
	await get_tree().create_timer(1).timeout
	Global.reset_data()

func audio_btn_pressed() -> void:
	audio_request.emit()

func other_btn_pressed() -> void:
	other_request.emit()