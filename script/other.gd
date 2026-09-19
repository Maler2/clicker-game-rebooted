extends Control

signal close_request_other
signal apply
signal bg_color_request

@onready var back_button: Button = $panel/vboxcontainer/close/button
@onready var panel: Panel = $panel
@onready var dark_check_button: CheckButton = $panel/vboxcontainer/dark_mode/CheckButton
@onready var bg_color: ColorPicker = $panel/vboxcontainer/color_bg/ColorPicker

func _ready() -> void:
	Global.preference_loading()

	if !bg_color.color_changed.is_connected(bg_color_changed):
		bg_color.color_changed.connect(bg_color_changed)
		
	await get_tree().process_frame

	bg_color.color = Global.bg_color

	dark_check_button.set_pressed_no_signal(Global.dark_mode)
	panel.self_modulate = Color(1, 1, 1, 0.5)
	visible = false
	position.y = -720
	back_button.pressed.connect(back_btn_pressed)
	dark_check_button.toggled.connect(dark_chk_btn_toggle)

func back_btn_pressed() -> void:
	Global.preference_saving()
	close_request_other.emit()

func dark_chk_btn_toggle(toggled_on: bool) -> void:
	if toggled_on:
		Global.dark_mode = true
		apply.emit()
	else:
		Global.dark_mode = false
		apply.emit()

func bg_color_changed(color: Color)-> void:
	print("color id: %s" % bg_color.color)
	Global.bg_color = color
	bg_color_request.emit(color)
