extends Control

signal close_request_other
signal apply

@onready var back_button: Button = $panel/vboxcontainer/close/button
@onready var panel: Panel = $panel
@onready var dark_check_button: CheckButton = $panel/vboxcontainer/HBoxContainer/CheckButton

func _ready() -> void:
    Global.preference_loading()
    dark_check_button.set_pressed_no_signal(Global.dark_mode)
    panel.self_modulate = Color(1, 1, 1, 0.5)
    visible = false
    position.y = -720
    back_button.pressed.connect(back_btn_pressed)
    dark_check_button.toggled.connect(dark_chk_btn_toggle)

func back_btn_pressed() -> void:
    close_request_other.emit()

func dark_chk_btn_toggle(toggled_on: bool) -> void:
    if toggled_on:
        print("test on")
        Global.dark_mode = true
        Global.preference_saving()
        apply.emit()
    else:
        print("test off")
        Global.dark_mode = false
        Global.preference_saving()
        apply.emit()