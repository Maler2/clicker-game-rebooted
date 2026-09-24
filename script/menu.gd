extends Control

signal close_request
signal anim_play_quit
signal setting_request

@onready var panel: Panel = $panel
@onready var close_button: Button = $panel/vboxcontainer/close/button
@onready var setting_button: Button = $panel/vboxcontainer/setting/button
@onready var quit_button: Button = $panel/vboxcontainer/quit/button
@onready var version_label: Label = $panel/vboxcontainer/version/label

func _ready() -> void:
	panel.self_modulate = Color(1, 1, 1, 0.5)
	visible = false
	position.y = -720
	close_button.pressed.connect(close_btn_pressed)
	quit_button.pressed.connect(quit_btn_pressed)
	setting_button.pressed.connect(setting_btn_pressed)
	var version: Variant = ProjectSettings.get_setting("application/config/version")
	if version == null or version == "":
		version_label.text = "0.1 (null)"
		push_warning("please input a version")
	else:
		version_label.text = version
		print("its %s (beta)" % version)

func close_btn_pressed() -> void:
	close_request.emit()

func setting_btn_pressed() -> void:
	setting_request.emit()

func quit_btn_pressed() -> void:
	get_window().borderless = true # failsafe
	Global.saving()
	Global.preference_saving()
	anim_play_quit.emit()
	await get_tree().create_timer(1).timeout
	get_tree().quit()
